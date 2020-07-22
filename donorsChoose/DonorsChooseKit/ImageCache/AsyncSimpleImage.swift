//
//  AsyncSimpleImage.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

public struct AsyncSimpleImage<Placeholder: View>: View, Identifiable {
    
    public let id:UUID = UUID()
    
    private let configuration: (Image) -> Image
    
    @ObservedObject private var loader: SimpleImageLoaderFileCached
    
    private let placeholder: Placeholder?
    
    public init(
        imageURLString: ImageKey?,
        placeholder: Placeholder? = nil,
        configuration: @escaping (Image) -> Image = { $0 }
    ) {
        loader = SimpleImageLoaderFileCached(
            imageKey: imageURLString,
            cache: staticCache
        )
        self.placeholder = placeholder
        self.configuration = configuration
    }
    
    public var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .renderingMode(.original)
                    .resizable()
                    //.scaledToFill()
                    .scaledToFit()
                    .clipped()
            } else {
                placeholder
                    //.frame(height:200)
                    .clipped()
            }
        }
    }
    
}


/**
 
 Usage:
 
 ForEach( model.imageKeys, id:\.self ) { key in
     NavigationLink(
         destination: ImagesDetailView<BoatMakeModel> (
             model: self.model
         )
     ){
         AsyncSimpleImage(
             imageURL: URL(string:"http://www.yack.com/someImage",
             placeholder: Text("Loading ..."),
             //imageCache: nil // self.cache
         )
     }
 }
 */
