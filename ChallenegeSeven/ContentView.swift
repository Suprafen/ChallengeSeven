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
    
    var frame: CGSize {
        !isZoomed ? size : CGSize(width: 250, height: 400)
    }
    
    var alignment: Alignment {
        !isZoomed ? .bottomTrailing : .center
    }
    
    private let cornerRadius: CGFloat = 10
    
    private let buttonText: String = "1"
    private let button: String = "2"
    private let plate: String = "3"
    
    @State private var plateOpacity: Double = 1
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(.blue.opacity(plateOpacity))
                    .frame(width: frame.width, height: frame.height)
                if isZoomed {
                    Button{
                        withAnimation {
                            isZoomed.toggle()
                        }
                    } label: {
                        Label("Back", systemImage: "arrowshape.backward.fill")
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: true, vertical: true)
                            .padding()
                            .matchedGeometryEffect(id: buttonText, in: animation)
                    }
                    .matchedGeometryEffect(id: button, in: animation)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            
            if !isZoomed {
                Button {
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
