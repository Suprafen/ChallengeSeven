//
//  ContentView.swift
//  ChallenegeSeven
//
//  Created by Ivan Pryhara on 17/03/2024.
//

import SwiftUI


struct RectPreference: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}

struct MyButtonStyle: ButtonStyle {
    @Binding var opacity: Double
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundStyle(.white)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
            .opacity(configuration.isPressed ? 0.5 : 1)
            .onChange(of: configuration.isPressed) { _, newValue in
                opacity = newValue == true ? 0.5 : 1
            }
    }
}

struct ContentView: View {
    @Namespace private var animation
    @State private var isZoomed = false
    @State private var size: CGSize = .zero
    
    @State private var plateOpacity: Double = 1
    @State private var showFlag: Bool = false
    @State private var now: Date = Date.now
    
    private var frame: CGSize {
        !isZoomed ? size : CGSize(width: 250, height: 400)
    }
    
    private var alignment: Alignment {
        !isZoomed ? .bottomTrailing : .center
    }
    
    private let cornerRadius: CGFloat = 10
    
    private let buttonText: String = "1"
    private let button: String = "2"
    private let plate: String = "3"
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .topLeading) {
                if showFlag {
                    TimelineView(.animation) { tl in
                        let start = now.distance(to: tl.date)
                        Image("us_flag")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .padding(20)
                            .background(.white.opacity(plateOpacity))
                            .drawingGroup()
                            .frame(width: frame.width, height: frame.height)
                            .visualEffect { content, geometryProxy in
                                content
                                    .distortionEffect(
                                        ShaderLibrary.relativeWave(.float2(geometryProxy.size),
                                                                   .float(start),
                                                                   .float(5),
                                                                   .float(20),
                                                                   .float(5)), maxSampleOffset: .zero)
                                    .opacity(isZoomed ? 1 : 0)
                            }
                            .onTapGesture {
                                withAnimation {
                                    showFlag.toggle()
                                }
                            }
                    }
                    .matchedGeometryEffect(id: plate, in: animation)
                    .transition(.scale)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundStyle(.blue.opacity(plateOpacity))
                        .frame(width: frame.width, height: frame.height)
                        .matchedGeometryEffect(id: plate, in: animation)
                        .onChange(of: isZoomed) { oldValue, newValue in
                            if newValue {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showFlag.toggle()
                                    }
                                }
                            }
                        }
                        .transition(.scale)
                }
                if isZoomed && !showFlag {
                    Button{
                        withAnimation {
                            isZoomed.toggle()
                        }
                    } label: {
                        Label("Back", systemImage: "arrowshape.backward.fill")
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: true, vertical: true)
                            .padding(showFlag ? 50 : 20)
                            .matchedGeometryEffect(id: buttonText, in: animation)
                    }
                    .matchedGeometryEffect(id: button, in: animation)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            
            if !isZoomed {
                Button {
                    now = Date.now
                    withAnimation {
                        isZoomed.toggle()
                    }
                } label: {
                    Text("Open")
                        .matchedGeometryEffect(id: buttonText, in: animation)
                }
                .background {
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: RectPreference.self, value: proxy.size)
                    }
                }
                .buttonStyle(MyButtonStyle(opacity: $plateOpacity))
                .matchedGeometryEffect(id: button, in: animation)
                .onPreferenceChange(RectPreference.self, perform: {
                    size = $0
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
