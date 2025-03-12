//
//  HomeView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            HStack {
                Text("Dashboard")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "calendar.circle.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("28 February 2025")
                    .padding(.bottom, 8)
                Grid {
                    GridRow {
                        VStack(alignment: .leading) {
                            Image(systemName: "square.and.arrow.down.fill")
                                .font(.title)
                            Spacer()
                            Text("50")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text("Product stock")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 180)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 8, x: -5, y: 6)
                        
                        VStack(alignment: .leading) {
                            Image(systemName: "square.and.arrow.up.fill")
                                .font(.title)
                            Spacer()
                            Text("50")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text("Product Sold")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 180)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 8, x: 5, y: 6)
                    }
                    .padding(.bottom, 16)

                    GridRow {
                        VStack(alignment: .leading) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.title)
                            Spacer()
                            Text("Rp5.000.000")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text("Money in stock")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 180)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 8, x: -5, y: 6)
                        
                        VStack(alignment: .leading) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.title)
                            Spacer()
                            Text("Rp5.000.000")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text("Money from sold products")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 180)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 8, x: 5, y: 6)
                    }
                    .padding(.bottom, 16)
                    
                    GridRow {
                        VStack(alignment: .leading) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.title)
                            Spacer()
                            Text("Rp5.000.000")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text("Gross margin")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 180)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 8, x: -5, y: 6)
                        
                        VStack(alignment: .leading) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.title)
                            Spacer()
                            Text("Rp5.000.000")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text("Net profit")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 180)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 8, x: 5, y: 6)
                    }
                    .padding(.bottom, 16)

                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
