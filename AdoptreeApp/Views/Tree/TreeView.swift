//
//  TreeView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI
import MapKit

struct TreeView: View {
    let tree: Tree
    let telemetry: Report?
    let sequestration: [Double]?
    let treeImage: TreeImage?
    let wildlife: [Wildlife]?
    
    var body: some View {
        VStack (alignment: .leading) {
            TreeHealthSection(healthBar: CGFloat(tree.health))
                .padding(.top)
            TreeDataSection(telemetry: telemetry, sequestration: sequestration)
            TreeGallerySection(treeImage: treeImage)
            TreeWildlifeSection(wildlife: wildlife)
            TreeLocationSection(tree: tree)
        }
    }
    
}

struct TreeHealthSection: View {
    @State var isShowing = false
    var healthBar: CGFloat
    
    var body: some View {
        
        //overall health
        RoundedRectangle(cornerRadius: 12.0)
            .fill(Color.init("color_gray"))
            .frame(width: .none, height: 110, alignment: .leading)
            .overlay(
                VStack(alignment: .center) {
                    Text("Overall Health")
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.init("color_font_primary"))
                    
                    Spacer(minLength: 10)
                    Text("Healthy")
                        .font(.body)
                        .foregroundColor(.init("color_font_primary"))
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(Color.gray)
                                .opacity(0.3)
                                .frame(width: geo.size.width * 0.9, height: 15.0, alignment: .center)
                            
                            Rectangle()
                                .foregroundColor(self.color)
                                .frame(width: self.isShowing ? (geo.size.width * 0.9) * (self.healthBar / 100.0) : 0.0, height: 15.0)
                                .animation(.linear(duration: 0.6))
                        }
                        .onAppear {
                            self.isShowing = true
                        }
                        .cornerRadius(10.0)
                        .frame(width: geo.size.width, height: .none, alignment: .center)
                    }
                }.padding(10))
            .padding(.bottom, 5)
    }
}

extension TreeHealthSection {
    
    var color: Color {
        if self.healthBar < 30 {
            return Color.red
        } else if self.healthBar > 30 && self.healthBar < 60 {
            return Color.yellow
        } else {
            return Color.init("color_primary_accent")
        }
    }
}

struct TreeDataSection: View {
    let telemetry: Report?
    let sequestration: [Double]?
   // var sequestrationsMock: [Double]? = [0.989273, 0.7126873, 0.827817, 0.2812727]
    
    var body: some View {
        // monitoring factors
//        if let telemetry = telemetry {
            HStack() {
                RoundedRectangle(cornerRadius: 12.0)
                    .fill(Color.init("color_gray"))
                    .frame(width: UIScreen.main.bounds.width * 0.43, height: 170, alignment: .center)
                    .overlay(
                        VStack(alignment: .center)  {
                            Text("CO2 Reduction")
                                .font(.title3)
                                .foregroundColor(Color.init("color_font_primary"))
                                .padding(.bottom, 30)
                            //Double(round(1000*x)/1000)
                            Text("\(String(format: "%.4f", getSequestration()))kg")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.init("color_font_primary"))
                                .padding(.bottom, 50)})
                
                RoundedRectangle(cornerRadius: 12.0)
                    .fill(Color.init("color_primary_accent"))
                    .frame(width: UIScreen.main.bounds.width * 0.43, height: 170, alignment: .center)
                    .overlay(
                        VStack(alignment: .center)  {
                            Text("Growth")
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 30)
                            
                            Text("\(telemetry?.treeLength ?? 0)cm")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 50)})
                    .offset(x: 0, y: 0)
            }
            HStack() {
                RoundedRectangle(cornerRadius: 12.0)
                    .fill(Color.init("color_gray"))
                    .frame(width: UIScreen.main.bounds.width * 0.43, height: 170, alignment: .center)
                    .overlay(
                        VStack(alignment: .center)  {
                            Text("Temperature")
                                .font(.title3)
                                .foregroundColor(Color.init("color_font_primary"))
                            
                            ZStack {
                                Circle()
                                    .stroke(temperatureColor, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20,0], dashPhase: 0))
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .padding(.bottom, 20)
                                Text("\(telemetry?.temperature ?? 0) °")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.init("color_font_primary"))
                                    .padding(.bottom, 20)
                            }
                        })
                
                RoundedRectangle(cornerRadius: 12.0)
                    .fill(Color.init("color_blue"))
                    .frame(width: UIScreen.main.bounds.width * 0.43, height: 170, alignment: .center)
                    .overlay(
                        VStack(alignment: .center)  {
                            Text("Humidity")
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 30)
                            
                            Text("\(telemetry?.humidity ?? 0)%")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 50)})
                    .offset(x: 0, y: 0)
            }.padding(.bottom, 5)
//        }
        
    }
}

extension TreeDataSection {
    
    var temperatureColor : Color {
        if let telemetry = telemetry {
            if telemetry.temperature <= 0 {
                return Color.init("color_blue")
            }else if telemetry.temperature > 0 && telemetry.temperature <= 10 {
                return Color.init("color_primary_accent")
            }else if telemetry.temperature > 10 && telemetry.temperature <= 20 {
                return Color.yellow
            }else if telemetry.temperature > 20 && telemetry.temperature <= 30 {
                return Color.orange
            }
        }
        return Color.red
    }
    
    func getSequestration() -> Double {
        if let sequestration = sequestration {
            let result = sequestration.reduce(0, +)
            let resultInGrams = Measurement(value: result, unit: UnitMass.grams)
            return resultInGrams.converted(to: .kilograms).value
        }
        
        return 0
    }
}

struct TreeGallerySection: View {
    let treeImage: TreeImage?
    var images = TreeImage(tree_id: 1, images: [ImageDetail(id: 1, tree_id: 1, image_blobname: "", alt: "", createdAt: Date(timeIntervalSince1970: 1605186555)), ImageDetail(id: 2, tree_id: 1, image_blobname: "", alt: "", createdAt: Date(timeIntervalSince1970: 1605186555))])
    
    var body: some View {
        
        //tree galery
        RoundedRectangle(cornerRadius: 12.0)
            .fill(Color.init("color_gray"))
            .frame(width: .none, height: 300, alignment: .leading)
            .overlay(
                VStack (alignment: .leading) {
                    HStack {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                            .foregroundColor(.init("color_primary_accent"))
                        
                        Text("Tree Gallery")
                            .foregroundColor(.init("color_font_primary"))
                            .font(.title3)
                        
                    }
                    
                    TabView {
                        if let treeImages = treeImage?.images {
                            ForEach (treeImages) { image in
                                Image(uiImage: getImage(using: image.image_blobname))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        } else {
                            Image(uiImage: UIImage(named: "happy_tree")!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 200)
                        }
                    }.tabViewStyle(PageTabViewStyle())
                    .cornerRadius(12.0)
                    
                }.frame(width: UIScreen.main.bounds.width * 0.8, height: 280, alignment: .topLeading))
            .padding(.bottom, 5)
    }
}

extension TreeGallerySection {
    
    func getImage(using name: String) -> UIImage {
        if let data = Data(base64Encoded: name) {
            return UIImage(data: data) ?? UIImage(named: "happy_tree")!
        }
        return UIImage(named: "happy_tree")!
    }
}

struct TreeWildlifeSection: View {
    let wildlife: [Wildlife]?
    var wildlifeMock = [Wildlife(id: 1, name: "Eurasian red squirrel", description: "Eurasian red squirrel"), Wildlife(id: 2, name: "Red squirrel", description: "Eurasian red squirrel"), Wildlife(id: 3, name: "Eurasian", description: "Eurasian red squirrel")]
    
    var body: some View {
        //wildlife
        VStack {
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.init("color_primary_accent"))
                    
                    Text("Wildlife")
                        .foregroundColor(.init("color_font_primary"))
                        .font(.title3)
                }
                
                Spacer()
                
                if let wildlife = wildlife {
                    ForEach(wildlife){ wildlife in
                        HStack {
                            Circle()
                                .fill(generateRandomColor())
                                .frame(width: 15, height: 15)
                            
                            Text("\(wildlife.name)")
                                .foregroundColor(.init("color_font_secondary"))
                                .font(.body)
                        }
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(10.0)
                        .padding(.bottom, 5.0)
                    }
                }else{
                    Text("No wildlife has been detected yet")
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.init("color_font_secondary"))
                        .font(.body)
                        .padding(.bottom, 5.0)
                }
                
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .topLeading)
        .background(Color.init("color_gray"))
        .cornerRadius(12.0)
        .padding(.bottom, 5)
        
    }
}

extension TreeWildlifeSection {
    
    func generateRandomColor() -> Color {
        return Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
}

struct TreeLocationSection: View {
    let tree: Tree
    @State var clicked:Bool = false
    @State private var isPresented = false
    
    var treeLocation: [Tree] {
        return [tree]
    }
    
    @State var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56.951924, longitude: 24.125584),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var body: some View {
        //location
        RoundedRectangle(cornerRadius: 12.0)
            .fill(Color.init("color_gray"))
            .frame(width: .none, height: 250, alignment: .leading)
            .overlay(
                VStack (alignment: .leading) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.init("color_primary_accent"))
                        
                        Text("Tree Location")
                            .foregroundColor(.init("color_font_primary"))
                            .font(.title3)
                        
                    }
                    
                    Spacer()
                    
                    if tree.coordinate.latitude == 0 && tree.coordinate.longitude == 0 {
                        Text("Tree location is unknown")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                            .offset(x: 50, y: -110)
                        
                    } else {
                        Map(coordinateRegion: $coordinateRegion,
                            annotationItems: treeLocation) { place in
                            MapMarker(coordinate: place.coordinate, tint: .init("color_primary_accent"))
                        }.padding(.bottom)
                        .onTapGesture() {
                            self.isPresented.toggle()
                        }
                        .sheet(isPresented: $isPresented) {
                            MapModalView(treeLocation: treeLocation, coordinateRegion: $coordinateRegion, isPresented: self.$isPresented)
                        }
                    }
                    
                }.frame(width: UIScreen.main.bounds.width * 0.8, height: 230, alignment: .topLeading))
            .padding(.bottom, 5)
            .onAppear {
                self.coordinateRegion = MKCoordinateRegion(
                    center: tree.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
    }
}

struct MapModalView: View {
    let treeLocation: [Tree]
    @Binding var coordinateRegion: MKCoordinateRegion
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $coordinateRegion,interactionModes: MapInteractionModes.all,
                annotationItems: treeLocation) { place in
                MapMarker(coordinate: place.coordinate, tint: .init("color_primary_accent"))
            }
            .edgesIgnoringSafeArea(.all)
            .overlay(
                Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Image(systemName: "escape")
                        .foregroundColor(.init("color_primary_accent"))
                        .padding(10)
                        .background(Color.init(.white))
                        .cornerRadius(5.0)
                })
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.85, alignment: .topLeading))
        }
    }
}

