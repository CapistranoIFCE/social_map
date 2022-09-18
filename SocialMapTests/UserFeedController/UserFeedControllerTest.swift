//
//  UserFeedControllerTest.swift
//  SocialMapTests
//
//  Created by Thiago Henrique on 14/09/22.
//

import XCTest
import MapKit
@testable import SocialMap
import CoreMIDI

class UserFeedControllerTest: XCTestCase {
    var mockController: UserFeedController!
    var landmarks: [UserImageAnnotation]!
    var rigthSequentialLandmarks: [UserImageAnnotation]!
    var leftSequentialLandmarks: [UserImageAnnotation]!
    
    override func setUp() {
        mockController = UserFeedController()
        
        rigthSequentialLandmarks = [
            UserImageAnnotation(
                title: "sut1",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: -3.7971866074375087, longitude: -38.56979534530145)
            ),
            UserImageAnnotation(
                title: "sut2",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: -3.74217, longitude: -38.53488)
            ),
            UserImageAnnotation(
                title: "sut3",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: -3.7264977742709626, longitude: -38.52656187487842)
            ),
        ]
        
        leftSequentialLandmarks = [
            UserImageAnnotation(
                title: "sut3",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: -3.7264977742709626, longitude: -38.52656187487842)
            ),
            UserImageAnnotation(
                title: "sut2",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: -3.74217, longitude: -38.53488)
            ),
            UserImageAnnotation(
                title: "sut1",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: -3.7971866074375087, longitude: -38.56979534530145)
            )
        ]
        
        landmarks = [
            UserImageAnnotation(
                title: "sut4",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            ),
            UserImageAnnotation(
                title: "sut5",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: 1.0, longitude: -1.0)
            ),
            UserImageAnnotation(
                title: "sut6",
                subtitle: "",
                coordinate: CLLocationCoordinate2D(latitude: 2.0, longitude: 1.0)
            )
        ]
    }
    
    //           SUT5 <- SUT4 -> SUT6

    
    func test_nearImageRight_shouldBe_valid() {
        let startAt = landmarks[0].coordinate
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
        let startAt = landmarks[0].coordinate
        let nearesleftLandmark = mockController.findNearLandmark(
            on: DeviceSide.left,
            in: landmarks,
            by: startAt
        )
        
        let expectedResult = "sut5"
        
        XCTAssertNotNil(nearesleftLandmark)
        XCTAssertEqual(nearesleftLandmark!.title, expectedResult)
    }
    
    func test_allNearRightImages_shouldBe_valid() {
        for (index, element) in rigthSequentialLandmarks.enumerated() {
            let startAt = element.coordinate
            
            let nearestRightLandmark = mockController.findNearLandmark(
                on: DeviceSide.right,
                in: rigthSequentialLandmarks,
                by: startAt
            )
            
            if index < rigthSequentialLandmarks.count - 1 {
                XCTAssertEqual(nearestRightLandmark, rigthSequentialLandmarks[index + 1])
            } else {
                XCTAssertNil(nearestRightLandmark)
            }
        }
    }
    
    func test_allNearLeftImages_shouldBe_valid() {
        for (index, element) in leftSequentialLandmarks.enumerated() {
            let startAt = element.coordinate
            
            let nearestLeftLandmark = mockController.findNearLandmark(
                on: DeviceSide.left,
                in: leftSequentialLandmarks,
                by: startAt
            )
            
            if index < leftSequentialLandmarks.count - 1 {
                XCTAssertEqual(nearestLeftLandmark, leftSequentialLandmarks[index + 1])
            } else {
                XCTAssertNil(nearestLeftLandmark)
            }
        }
    }
}
