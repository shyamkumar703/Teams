//
//  TeamPickedView.swift
//  Teams
//
//  Created by Shyam Kumar on 1/1/23.
//

import SwiftUI

struct TeamPickedView: View {
    @State var backgroundHeight: CGFloat = 0
    @State var team: TeamImageColor
    @State var shouldShowTeamAndLogo: Bool = false
    var viewModel: ViewModel
    
    var backgroundAnimationTime: Double = 0.3
    var teamAndLogoAnimationTime: Double = 0.2
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(Color(hex: team.colors[0].hex) ?? .black)
                        .frame(width: UIScreen.main.bounds.width, height: backgroundHeight, alignment: .bottom)
                        .onAppear {
                            withAnimation(.easeIn(duration: backgroundAnimationTime)) {
                                backgroundHeight = UIScreen.main.bounds.height
                            }
                        }
                    
                    if shouldShowTeamAndLogo {
                        VStack(alignment: .center) {
                            Spacer()
                                .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top + 20)
                            
                            PrimarySecondaryText(
                                primary: team.teamName,
                                secondary: "\(team.cityName)\n",
                                font: .largeTitle,
                                primaryColor: .white,
                                secondaryColor: .secondaryTextOnBlack,
                                textOrdering: .secondaryFirst
                            )
                            
                            Image(team.imageName)
                                .resizable()
                                .frame(width: 100, height: 100)
                            
                            Spacer()
                            
                            NavigationLink(destination: GamesView(viewModel: viewModel.gamesViewModel)) {
                                Button("NEXT", action: {})
                                    .frame(width: UIScreen.main.bounds.width - 40, height: 40, alignment: .center)
                                    .buttonStyle(.plain)
                                    .foregroundColor(.black)
                                    .background(Color(hex: team.colors[1].hex))
                                    .cornerRadius(20)
                                    .font(.mediumTitleSmall)
                                    .padding()
                            }
                            
                            Spacer()
                                .frame(width: geometry.size.width, height: geometry.safeAreaInsets.bottom + 40)
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + backgroundAnimationTime) {
                    withAnimation {
                        UIImpactFeedbackGenerator().impactOccurred()
                        shouldShowTeamAndLogo.toggle()
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension TeamPickedView {
    class ViewModel {
        private var dependencies: AllDependencies
        var gamesViewModel: GamesView.ViewModel {
            GamesView.ViewModel(dependencies: dependencies)
        }
        init(dependencies: AllDependencies) {
            self.dependencies = dependencies
        }
    }
}

//struct TeamPickedView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamPickedView()
//    }
//}
