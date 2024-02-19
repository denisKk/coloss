//
//  SelectCategoryView.swift
//  coloss
//
//  Created by Dev on 17.02.24.
//

import SwiftUI

struct SelectCategoryView: View {
    
    @Environment(\.networkAPI) var network
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategory: Category?
    @State var searchText: String = ""
    
    let allCategories: [Category]
    
    var body: some View {
        VStack {
            
            Text("All categories")
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            searchBar
                .padding(.leading, 15)
                .padding(.trailing, 15)
            Divider().background(Color.gray)
                .padding(.top, 10)
            
            ScrollView {
                LazyVStack {

                    ForEach(searchResults) {category in
                        VStack {
                            Text(category.title)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.gray.opacity(0.1).gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        .onTapGesture {
                            selectedCategory = category
                            dismiss()
                        }
                        
                    }
                }
                
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Search", text: $searchText)
                .font(Font.system(size: 21))
        }
        .padding(7)
        .cornerRadius(50)
    }
    
    var searchResults: [Category] {
        if searchText.isEmpty {
            return allCategories
        } else {
            return allCategories.filter { $0.title.contains(searchText) }
        }
    }
    
}

#Preview {
    SelectCategoryView(selectedCategory: .constant(Category(title: "sstg")), allCategories: [])
}
