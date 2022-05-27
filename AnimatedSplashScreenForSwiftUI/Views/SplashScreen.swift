//
//  SplashScreen.swift
//  AnimatedSplashScreenForSwiftUI
//
//  Created by Quin on 2022/5/27.
//

import SwiftUI

// Custom View Builder...
struct SplashScreen<Content: View, Title: View, Logo: View, NavButton: View>: View {
    
    var contentView: Content
    var titleView: Title
    var logoView: Logo
    var navButton: NavButton
    var imageSize: CGSize
    // nav buttons...
    
    
    init(imageSize: CGSize, @ViewBuilder contentView: @escaping () -> Content, @ViewBuilder titleView: @escaping () -> Title, @ViewBuilder logoView: @escaping () -> Logo, @ViewBuilder navButton: @escaping () -> NavButton) {
        self.contentView = contentView()
        self.titleView = titleView()
        self.logoView = logoView()
        self.navButton = navButton()
        self.imageSize = imageSize
    }
    
    // animation properties...
    @State var textAnimation = false
    @State var imageAnimation = false
    @State var endAnimation = false
    @State var showNavButton = false
    // namespace...
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color("Purple")
                // were not going to do complex reading of top edge...
                // simply apply overlay or background it will automatically fill edges...
                   .background(Color("Purple"))
                // but the frame will be safe area...
                   .overlay(
                        ZStack {
                            titleView
                            // scaling text...
                                .scaleEffect(endAnimation ? 0.7: 1)
                                .offset(y: textAnimation ? -5 : 110)
                            if !endAnimation {
                                logoView
                                    .matchedGeometryEffect(id: "LOGO", in: animation)
                                    .frame(width: imageSize.width, height: imageSize.height)
                            }
                        }
                   )
                   .overlay(
                        // moving right...
                        HStack {
                            // later used for nav buttons...
                            navButton
                                .opacity(showNavButton ? 1 : 0)
                            Spacer()
                            if endAnimation {
                                logoView
                                    .matchedGeometryEffect(id: "LOGO", in: animation)
                                    .frame(width: 30, height: 30)
                                    .offset(y: -5)
                            }
                        }
                        .padding(.horizontal)
                   )
            }
            // decreasing size when animation ended...
            // your own vale...
            .frame(height: endAnimation ? 60 : nil)
            .zIndex(1)
            // home view...
            contentView
                .frame(height: endAnimation ? nil : 0)
            // moving back view...
                .zIndex(0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            // starting animation with some delay...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring()) {
                    textAnimation.toggle()
                }
                // directly ending animation...
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 1, blendDuration: 1)) {
                    endAnimation.toggle()
                }
                // showing after some delay...
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    withAnimation {
                        showNavButton.toggle()
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
