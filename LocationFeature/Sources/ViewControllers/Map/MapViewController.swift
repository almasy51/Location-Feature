//
//  MapViewController.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/22/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    // MARK: Outlets
    
    //@IBOutlet private var searchAreaButton: SearchAreaButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet private var tableView: UITableView!
    
    // MARK: Properties

    private var locationManager = CLLocationManager()

    private var locations = [MapLocationModel]()

    private let footerHeight: CGFloat = 480

    private var radius: Double = 0.0

    private let viewModel: MapLocationsViewModelType = MapLocationsViewModel()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        setupTableView()
        getLocations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func getLocations() {
        radius = mapView.currentRadius()
        viewModel.loadLocations()
        refreshAnnotations()
        tableView.reloadData()
    }

    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
    }

    @objc func didTapMapView(recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: mapView)
        if let subview = mapView.hitTest(tapLocation, with: nil) {
            if !subview.isKind(of: MKAnnotationView.self) {
                collapseDrawer()
            }
        }
    }

    func collapseDrawer() {
        let offset = CGFloat(Constants.Cells.locationDotsCellHeight) - tableView.height
        let headerHeight = CGPoint(x: 0, y: offset)
        tableView.setContentOffset(headerHeight, animated: false)
    }
    
    func lengthFromTableViewToTop() -> CGFloat {
        if let firstCell = tableView.visibleCells.first {
            let mapViewSuperViewPoint = view.convert(mapView.frame.origin, to: nil)
            let tableViewSuperViewPoint = tableView.convert(firstCell.frame.origin, to: view)
            return abs(mapViewSuperViewPoint.y - tableViewSuperViewPoint.y)
        } else {
            return view.height - CGFloat(Constants.Cells.locationDotsCellHeight)
        }
    }
    
    func refreshAnnotations() {
        if let locations = viewModel.locations {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(locations)
            zoomToFitMapAnnotations(mapView)
        }
    }

    // MARK: Actions

    @IBAction func searchAreaAction(_ sender: UIBarButtonItem) {
        let nePoint = CGPoint(x: mapView.bounds.width + mapView.bounds.origin.x, y: mapView.bounds.origin.y)
        
        let swPoint = CGPoint(x: mapView.bounds.origin.x, y: mapView.bounds.origin.y + mapView.bounds.height - lengthFromTableViewToTop())
        
        let neCoordinate = mapView.convert(nePoint, toCoordinateFrom: mapView)
        let swCoordinate = mapView.convert(swPoint, toCoordinateFrom: mapView)
        
        let location = CLLocation(latitude: (neCoordinate.latitude + swCoordinate.latitude) * 0.5, longitude: (neCoordinate.longitude + swCoordinate.longitude) * 0.5)
        viewModel.sortLocations(location: location)
        collapseDrawer()
        refreshAnnotations()
        tableView.reloadData()
    }
    
    @IBAction func focusOnUserLocationAction(_ sender: Any) {
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
            collapseDrawer()
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - UITableView Data Source Methods

extension MapViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(Constants.Cells.locationDotsCellHeight)
        }
        return CGFloat(Constants.Cells.locationCellHeight)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.locations?.count ?? 0) > 0 ? (viewModel.locations?.count ?? 0) + 1 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: LocationDotsCell = tableView.dequeueReusableCell(withClass: LocationDotsCell.self, for: indexPath)
            return cell
        } else {
            let cell: LocationDescriptionCell = tableView.dequeueReusableCell(withClass: LocationDescriptionCell.self, for: indexPath)
            cell.setup(location: viewModel.getLocation(index: indexPath.row - 1))
            return cell
        }
    }

}

// MARK: - UITableView Delegate Methods

extension MapViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let coordinate = viewModel.locations?[optional: indexPath.row - 1]?.coordinate {
            collapseDrawer()
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
            mapView.setRegion(region, animated: true)
        }
    }

}

extension MapViewController: UIScrollViewDelegate {

    /// Allows the TableView to seamlessly drag from the bottom to the top of the view
    ///
    /// Calculate the minimum value to the top of the view, the value of the first 3 cells, and the
    /// value of the top cell only
    /// Prevent the Tableview from going past the top "handle" cell
    /// Flunctuate the end position based on the three values calculated above
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let yMin: CGFloat = -tableView.contentInset.top
        let firstThreeCellHeight = CGFloat(2 * Constants.Cells.locationCellHeight)
        let midPointBottom = firstThreeCellHeight / 2
        let tableViewContentSizeAdjusted = CGFloat(tableView.contentSize.height - footerHeight)
        let midPointTop = min((tableViewContentSizeAdjusted - firstThreeCellHeight) / 2,
                              (tableView.height - firstThreeCellHeight) / 2)
        let yMax: CGFloat = min(0, tableViewContentSizeAdjusted - tableView.height)
        let yMid: CGFloat = -(abs(yMin) - firstThreeCellHeight)

        if targetContentOffset.pointee.y < yMax {
            if targetContentOffset.pointee.y <= yMid + midPointTop &&
                targetContentOffset.pointee.y >= yMid - midPointBottom {
                let point = CGPoint(x: 0, y: yMid)
                scrollView.setContentOffset(point, animated: true)
            } else if targetContentOffset.pointee.y < 0 {
                targetContentOffset.pointee.y = yMin
            } else if  targetContentOffset.pointee.y < yMid - midPointBottom {
                targetContentOffset.pointee.y = CGFloat(Constants.Cells.locationDotsCellHeight) - tableView.height
            }
        }
    }

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        viewModel.loadLocations()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    /// Zooms to fit all pins on the screen
    ///
    /// Removes user annotation
    /// Sorts closest annotations
    /// Creates a frame with all of the annotations
    /// Gets the distance from the top of the MapView to the Top of the first visible TableView Cell
    /// Adds padding to ensure all annotations appear on the screen and above the TableView Cells
    func zoomToFitMapAnnotations(_ mapView: MKMapView) {
        if mapView.annotations.count == 0 ||
            (mapView.annotations.count == 1 &&
                mapView.annotations[0].coordinate.latitude == mapView.userLocation.coordinate.latitude &&
                mapView.annotations[0].coordinate.longitude == mapView.userLocation.coordinate.longitude) {
            return
        }

        let annotations = removeUserAnnotationFromMapScope()

        if let firstAnnotation = annotations.first {
            var minPoint = MKMapPoint(firstAnnotation.coordinate)
            var maxPoint = minPoint
            for annotation in annotations {
                let point = MKMapPoint(annotation.coordinate)
                if point.x < minPoint.x {
                    minPoint.x = point.x
                }
                if point.y < minPoint.y {
                    minPoint.y = point.y
                }
                if point.x > maxPoint.x {
                    maxPoint.x = point.x
                }
                if point.y > maxPoint.y {
                    maxPoint.y = point.y
                }
            }
            let rect = MKMapRect(origin: MKMapPoint(x: minPoint.x, y: minPoint.y), size: MKMapSize(width: maxPoint.x - minPoint.x, height: maxPoint.y - minPoint.y))
            
            let padding = UIEdgeInsets(top: 44, left: 20, bottom: lengthFromTableViewToTop(), right: 20)

            MKMapView.animate(withDuration: 1.0, animations: {
                mapView.setVisibleMapRect(rect, edgePadding: padding, animated: true)
            })
        }
    }

    func removeUserAnnotationFromMapScope() -> [MKAnnotation] {
        var annotations = [MKAnnotation]()

        for annotation in mapView.annotations {
            if !(annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude &&
                annotation.coordinate.longitude == mapView.userLocation.coordinate.longitude) {
                annotations.append(annotation)
            }
        }

        return annotations
    }
}

// MARK: - Private Methods

private extension MapViewController {

    func setupMapView() {
        locationManager.requestWhenInUseAuthorization()

        mapView.showsUserLocation = true
        radius = mapView.currentRadius()
        mapView.register(
            LocationMarkerView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
        )
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMapView))
        mapView.addGestureRecognizer(tapRecognizer)
    }

    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        checkLocationAuthorizationStatus()
    }

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(
            top: tableView.frame.size.height - CGFloat(Constants.Cells.locationDotsCellHeight),
            left: 0,
            bottom: -footerHeight,
            right: 0
        )
        tableView.contentOffset = CGPoint(x: 0, y: -tableView.contentInset.top)
        setupTableViewFooterView()
    }

    func setupTableViewFooterView() {
        /// Append white space to bottom of tableView
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerHeight))
        footerView.backgroundColor = .white
        tableView.tableFooterView = footerView
    }
    
}
