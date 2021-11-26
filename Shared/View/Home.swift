//
//  Home.swift
//  UI-338 (iOS)
//
//  Created by nyannyan0328 on 2021/10/21.
//

import SwiftUI

struct Home: View {
    @State var introls : [Intro] = [
        
        Intro(title: "Plan", subTitle: "your routes", description: "View your collection route Follow, change or add to your route yourself", pic: "Pic1",color: Color("Green")),
        Intro(title: "Quick Waste", subTitle: "Transfer Note", description: "Record oil collections easily and accurately. No more paper!", pic: "Pic2",color: Color("DarkGrey")),
        Intro(title: "Invite", subTitle: "restaurants", description: "Know some restaurant who want to optimize oil collection? Invite them with one click", pic: "Pic3",color: Color("Yellow")),
    
    
    ]
    
    
    @GestureState var isDragging : Bool = false
    
    @State var fakeIndex : Int = 0
    @State var currentIndex : Int = 0
    var body: some View {
        
        ZStack{
            
            ForEach(introls.indices.reversed(),id:\.self){index in
                
                cardView(intro: introls[index])
                    .clipShape(CustomShape(offset: introls[index].offset, curvePoint: fakeIndex == index ? 50 : 0))
                    .padding(.trailing,fakeIndex == index ? 15 : 0)
                    .ignoresSafeArea()
                   
                
                
            }
            
            HStack{
                
                
                ForEach(0..<introls.count - 2,id:\.self){intro in
                    
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 9, height: 9)
                        .scaleEffect(currentIndex == intro ? 1.5 : 0.8)
                        .opacity(currentIndex == intro ? 1 : 0.25)
                    
                    
                    
                }
                
                Spacer()
                
                
                
                Button {
                    
                } label: {
                    
                    Text("Skip")
                        .font(.title3)
                        .foregroundColor(.white)
                }

                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding()
            .padding(.horizontal)
            
            
            
            
        }
       
        .overlay(
        
            Button(action: {
                
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.largeTitle.bold())
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .contentShape(Rectangle())
                    .gesture(
                    
                        DragGesture().updating($isDragging, body: { value, out, _ in
                            out = true
                        })
                            .onChanged({ value in
                                
                                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6)){
                                    
                                    introls[fakeIndex].offset = isDragging ? value.translation : .zero
                                    
                                    
                                }
                                
                            })
                            .onEnded({ value in
                                
                                withAnimation(.spring()){
                                    
                                    if -introls[fakeIndex].offset.width > getRect().width / 2{
                                        
                                        
                                        introls[fakeIndex].offset.width = -getRect().height * 1.5
                                        
                                        
                                        fakeIndex += 1
                                        
                                        
                                        if currentIndex == introls.count - 3{
                                            
                                            
                                            currentIndex = 0
                                        }
                                        else{
                                            
                                            currentIndex += 1
                                        }
                                        
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            
                                            
                                            if fakeIndex == (introls.count - 2){
                                                
                                                for index in 0..<introls.count - 2{
                                                    
                                                    introls[index].offset = .zero
                                                    
                                                    
                                                }
                                                fakeIndex = 0
                                                
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    else{
                                        
                                        introls[fakeIndex].offset = .zero
                                    }
                                    
                                    
                                }
                                
                            })
                    
                    )
                
                
            })
                .offset(y: 60)
                .opacity(isDragging ? 0 : 1)
                .animation(.linear, value: isDragging)
            
            
            ,alignment: .topTrailing
        
        )
        .onAppear {
            guard let first = introls.first else{return}
            
            guard var last = introls.last else{return}
            
            last.offset.width = -getRect().height * 1.5
            
            introls.append(first)
            introls.insert(last, at: 0)
            
            
            fakeIndex = 1
            
            
            
        }
       
    }
    @ViewBuilder
    func cardView(intro : Intro)->some View{
        
        VStack{
            
            Image(intro.pic)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(50)
           
            
            VStack(alignment: .leading, spacing: 16) {
              
                Text(intro.title)
                    .font(.system(size: 50, weight: .bold))
                
            
                
                Text(intro.subTitle)
                    .font(.system(size: 40, weight: .bold))
                
                    
                Text(intro.description)
                    .font(.title2.bold())
                    .padding(.top,10)
                    .frame(width: getRect().width - 100)
                    .lineSpacing(13)
                    
                
               
                
                
            }
            .foregroundColor(.white)
            .padding(.leading,10)
            .padding([.trailing,.top])
            .frame(maxWidth: .infinity,alignment: .leading)
             
            
            
        }
        
       
        
       .frame(maxWidth: .infinity, maxHeight: .infinity)
       
        .background(

            intro.color

        )
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
struct CustomShape : Shape{
    
    var offset : CGSize
    var curvePoint : CGFloat
    
   
    var animatableData: AnimatablePair<CGSize.AnimatableData,CGFloat>{
        
        get{
            
            
            return AnimatablePair(offset.animatableData,curvePoint)
           
        }
        
        set{
            
            offset.animatableData = newValue.first
            curvePoint = newValue.second
            
            
        }
        
        
    }
    
    func path(in rect: CGRect) -> Path {
        return Path {path in
            
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)//move
            //正方形
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let from = 80 + (offset.width)
            path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
            
            var to = 180 + (offset.height) + (-offset.width)
            
            to = to < 180 ? 180 : to
           
            let mid : CGFloat = 80 + ((to - 80) / 2)
            
             //to -> どこに行く y->vertical //
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - curvePoint, y: mid), control2: CGPoint(x: width - curvePoint, y: mid))
            
        }
    }
}
