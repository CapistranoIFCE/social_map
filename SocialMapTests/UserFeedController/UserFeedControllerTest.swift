//
//  UserFeedControllerTest.swift
//  SocialMapTests
//
//  Created by Thiago Henrique on 14/09/22.
//

import XCTest
import MapKit
@testable import SocialMap

class UserFeedControllerTest: XCTestCase {
    var mockController: UserFeedController!
    var landmarks: [LandmarkAnnotation]!
    
    override func setUp() {
        mockController = UserFeedController()
        landmarks = [
            LandmarkAnnotation(
                title: "sut1",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: -3.7971866074375087, longitude: -38.56979534530145)
            ),
            LandmarkAnnotation(
                title: "sut2",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: -3.74217, longitude: -38.53488)
            ),
            LandmarkAnnotation(
                title: "sut3",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: -3.7264977742709626, longitude: -38.52656187487842)
            ),
            LandmarkAnnotation(
                title: "sut4",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            ),
            LandmarkAnnotation(
                title: "sut5",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: 1.0, longitude: -1.0)
            ),
            LandmarkAnnotation(
                title: "sut6",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: 2.0, longitude: 1.0)
            )
        ]
    }
    
    //           SUT5 <- SUT4 -> SUT6

    
    func test_nearImageRight_shouldBe_valid() {
        let startAt = landmarks[3].coordinate
        let nearestRigthLandmark = mockController.findNearLandmark(
            on: DeviceSide.right,
            in: landmarks,
            by: startAt
        )
        
        let expectedResult = "sut6"
        
        XCTAssertNotNil(nearestRigthLandmark)
        XCTAssertEqual(nearestRigthLandmark!.title, expectedResult)
    }
    
    func test_nearImageLeft_shouldBe_valid() {
        let startAt = landmarks[3].coordinate
        let nearesleftLandmark = mockController.findNearLandmark(
            on: DeviceSide.left,
            in: landmarks,
            by: startAt
        )
        
        let expectedResult = "sut5"
        
        XCTAssertNotNil(nearesleftLandmark)
        XCTAssertEqual(nearesleftLandmark!.title, expectedResult)
    }
    
    func test_allNearImage
}
