//
//  UserStoriesView.swift
//  SocialMap
//
//  Created by Raina Rodrigues de Lima on 15/09/22.
//

import Foundation
import MapKit

struct UserStoriesView: View{
    
    struct SaveImageUserFlow: View {
        //@State var text = ""
        
//        @State private var region = MKCoordinateRegion (
//            center: CLLocationCoordinate2D(
//                latitude: 51.507222,
//                longitude: -0.1275
//            ),
//            span: MKCoordinateSpan (
//                latitudeDelta: 0.1,
//                longitudeDelta: 0.1
//            )
//        )
        
        let userStories = [
            UserStory(
                identifier: "Laughing",
                image: "friends_laughing",
                contentType: MediaType.image,
                location: Location(latitude: -3.74217, longitude: -38.53488)
            ),
            UserStory(
                identifier: "Climb a Mountain",
                image: "mountain",
                contentType: MediaType.image,
                location: Location(latitude: -3.7365736405651586, longitude: -38.50111281535821)
            ),
            UserStory(
                identifier: "Me and girls",
                image: "three_friends_laughing",
                contentType: MediaType.image,
                location: Location(latitude: -3.7921852010381736, longitude: -38.50188465953605)
            ),
            UserStory(
                identifier: "Beautiful Sunset",
                image: "friends_sunset",
                contentType: MediaType.image,
                location: Location(latitude: -3.7264977742709626, longitude: -38.52656187487842)
            ),
            UserStory(
                identifier: "Beach Sunset",
                image: "sunset_beach",
                contentType: MediaType.image,
                location: Location(latitude: -3.7971866074375087, longitude: -38.56979534530145)
            )
        ]
        
        
        @State private var count = 0
        
        var body: some View {
            NavigationView {
                ZStack {
                    
                    //GeometryReader { (geometry) in
                        //MapView(coordinate: region.center).ignoresSafeArea()
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                        Spacer()
                        HStack {
                            ForEach(userStories) { story in
                                UserComponentStory(image: story.image, name: story.identifier)
    //                                .onTapGesture {
    //                                    region.center = CLLocationCoordinate2D (
    //                                        latitude: story.location.latitude,
    //                                        longitude: story.location.longitude
    //                                    )
    //                                }
                            }
                            
                        }
                        .frame(minWidth: CGFloat(userStories.count) * (geometry.size.width / 4), alignment: .leading)
                        //.padding(0)
                        //.background { Color.white}
                        //.cornerRadius(10)
                    }
                        
                        HStack {
                            Rectangle()
                                .frame(width: geometry.size.width * 0.1, height: geometry.size.height)
                                .onTapGesture(count: 2, perform: {
                                    let currentUserLocation = userStories[count].location
                                    region.center = CLLocationCoordinate2D (
                                        latitude: currentUserLocation.latitude,
                                        longitude: currentUserLocation.longitude
                                    )
                                    count += 1
                                    if count >= userStories.count {
                                        count = 0
                                    }
                                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                } )
                                .onTapGesture {
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }
                                .foregroundColor(.blue.opacity(0.00001))
                            
                            Spacer()
                           
                            
                            Rectangle()
                                .frame(width: geometry.size.width * 0.1, height: geometry.size.height)
                                .onTapGesture(count: 2, perform: {
                                    let currentUserLocation = userStories[count].location
                                    region.center = CLLocationCoordinate2D (
                                        latitude: currentUserLocation.latitude,
                                        longitude: currentUserLocation.longitude
                                    )
                                    count -= 1
                                    if count <= 0 {
                                        count = 0
                                    }
                                } )
                                .foregroundColor(.blue.opacity(0.00001))
                            
                        }
                    }
                }.navigationTitle("Social Map")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("plus tapped!")
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }

            }
        }
    }



    struct SaveImageUserFlow_Previews: PreviewProvider {
        static var previews: some View {
            SaveImageUserFlow()
        }
    }
