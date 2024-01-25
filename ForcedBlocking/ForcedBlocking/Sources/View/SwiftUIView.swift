//
//  SwiftUIView.swift
//  ForcedBlocking
//
//  Created by 박준하 on 1/22/24.
//

import SwiftUI

struct SwiftUIView: View {
    @EnvironmentObject var model: BlockingModel
    @State private var isPresented = false

    var body: some View {
        VStack {
            Button(action: { isPresented.toggle() }) {
                Text("앱 차단 목록 불러오기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .familyActivityPicker(isPresented: $isPresented, selection: $model.newSelection)
            .padding(.top, 20)
        }
        .padding(.horizontal, 16)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
