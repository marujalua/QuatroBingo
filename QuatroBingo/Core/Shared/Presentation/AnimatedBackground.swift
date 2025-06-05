//
//  AnimatedBackground.swift
//  QuatroBingo
//
//  Created by Marcos Chevis on 30/05/25.
//

import SwiftUI

extension View {
    func animatedBackground() -> some View {
        modifier(AnimatedViewBackgroundModifier())
    }
}

struct AnimatedViewBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AnimatedBackgroundView().frame(maxWidth: .infinity, maxHeight: .infinity)
            content
        }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(AnimatedViewBackgroundModifier())
}

struct AnimatedBackgroundView: View {
    let shouldAnimate = true
    let backGroundColor: Color = .accent
    let blurRadius: CGFloat = 30
    @State var data: [BlobData] = defaultBlobs

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                context.addFilter(.blur(radius: blurRadius))
                data.forEach { element in
                    context.drawLayer { ctx in
                        let path = element.shape.path(in: CGRect(origin: CGPoint(x: 0, y: 0), size: element.size))
                            .rotated(by: element.angleInfo.current)
                        ctx.translateBy(x: element.positionInfo.current.x, y: element.positionInfo.current.y)
                        ctx.fill(path, with: .color(element.color))
                    }
                }
            }
            .ignoresSafeArea()
            .background(backGroundColor)
            .onChange(of: timeline.date) { _, _ in
                updateState()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                timeline.invalidateTimelineContent()
            }
        }
    }

    private func updateState() {
        guard shouldAnimate else { return }
        let newState = data.map { element in
            var element = element
            let angleMax = max(element.angleInfo.ending, element.angleInfo.starting)
            let angleMin = min(element.angleInfo.ending, element.angleInfo.starting)
            if angleMax > angleMin {
                let range = (angleMin...angleMax)
                if !range.contains(element.angleInfo.current) { element.angleInfo.rate *= -1 }
            }
            let maxX = max(element.positionInfo.ending.x, element.positionInfo.starting.x)
            let minX = min(element.positionInfo.ending.x, element.positionInfo.starting.x)
            if maxX > minX {
                let range = (minX...maxX)
                if !range.contains(element.positionInfo.current.x) { element.positionInfo.rate.x *= -1 }
            }
            let maxY = max(element.positionInfo.ending.y, element.positionInfo.starting.y)
            let minY = min(element.positionInfo.ending.y, element.positionInfo.starting.y)
            if maxY > minY {
                let range = (minY...maxY)
                if !range.contains(element.positionInfo.current.y) { element.positionInfo.rate.y *= -1 }
            }

            element.angleInfo.current += element.angleInfo.rate
            element.positionInfo.current.x += element.positionInfo.rate.x
            element.positionInfo.current.y += element.positionInfo.rate.y
            return element
        }
        data = newState

    }
}


let screen = UIScreen.main.bounds
let screenWidth = screen.width
let screenHeight = screen.height

let defaultBlobs: [BlobData] = [
    .init(
        angleInfo: .init(starting: .zero, ending: .degrees(45), rate: .degrees(0.01)),
        positionInfo: .init(
            starting: CGPoint(x: screenWidth * -0.13, y: screenHeight * 0.55),
            ending: CGPoint(x: screenWidth * 0.18, y: screenHeight * 0.5),
            rate: CGPoint(x: 0.1, y: 0.1)
        ),
        color: Color.secondaryAccent,
        size: CGSize(width: screenWidth * 0.9, height: screenHeight * 0.45),
        shape: RED()
    ),
    .init(
        angleInfo: .init(starting: .zero, ending: .degrees(-60), rate: .degrees(-0.01)),
        positionInfo: .init(
            starting: CGPoint(x: screenWidth * 0.025, y: screenHeight * 0.04),
            ending: .zero,
            rate: .zero
        ),
        color: Color.secondaryAccent,
        size: CGSize(width: screenWidth * 1.2, height: screenHeight * 1.0),
        shape: GREEN()
    ),
    .init(
        angleInfo: .init(starting: .degrees(0), ending: .degrees(15), rate: .degrees(0.02)),
        positionInfo: .init(
            starting: CGPoint(x: screenWidth * 0.4, y: screenHeight * 0.49),
            ending: CGPoint(x: screenWidth * 0.27, y: screenHeight * 0.32),
            rate: CGPoint(x: 0, y: 0.1)
        ),
        color: Color.tertiaryAccent,
        size: CGSize(width: screenWidth * 0.7, height: screenHeight * 0.52),
        shape: BLUE()
    ),
    .init(
        angleInfo: .init(starting: .zero, ending: .degrees(20), rate: .degrees(0.03)),
        positionInfo: .init(
            starting: CGPoint(x: screenWidth * -0.37, y: screenHeight * 0.32),
            ending: CGPoint(x: screenWidth * -0.05, y: screenHeight * 0.31),
            rate: CGPoint(x: 0.05, y: 0.05)
        ),
        color: .tertiaryAccent,
        size: CGSize(width: screenWidth * 0.6, height: screenHeight * 0.45),
        shape: CYAN()
    ),
    .init(
        angleInfo: .init(starting: .zero, ending: .degrees(-20), rate: .degrees(0.01)),
        positionInfo: .init(
            starting: CGPoint(x: screenWidth * 0.21, y: 0),
            ending: CGPoint(x: screenWidth * -0.34, y: screenHeight * 0.06),
            rate: CGPoint(x: -0.01, y: 0.01)
        ),
        color: .tertiaryAccent,
        size: CGSize(width: screenWidth * 0.43, height: screenHeight * 0.45),
        shape: BLACK()
    )
]

struct BlobData {
    var angleInfo: AngleData
    var positionInfo: PositionData
    let color: Color
    let size: CGSize
    let shape: any Shape
}
struct AngleData {
    let starting: Angle
    let ending: Angle
    var rate: Angle
    var current: Angle

    init(starting: Angle, ending: Angle, rate: Angle) {
        self.starting = starting
        self.ending = ending
        self.current = starting
        self.rate = rate
    }

}
struct PositionData {
    let starting: CGPoint
    let ending: CGPoint
    var rate: CGPoint
    var current: CGPoint

    init(starting: CGPoint, ending: CGPoint, rate: CGPoint) {
        self.starting = starting
        self.ending = ending
        self.current = starting
        self.rate = rate
    }
}


extension Path {
    func rotated(by angle: Angle, anchor: UnitPoint = .center) -> Self {
        self.rotation(angle, anchor: anchor).path(in: self.boundingRect)
    }
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        var origin = CGPoint(x: center.x, y: center.y)
        origin.x -= size.width/2
        origin.y -= size.height/2

        self.init(origin: origin, size: size)
    }
}

struct BLACK: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 237.5, y: 223))
        path.addCurve(to: CGPoint(x: 64.5, y: 49.5),
                      control1: CGPoint(x: 252.5, y: 94.4999),
                      control2: CGPoint(x: 84.5, y: 49.5))
        path.addCurve(to: CGPoint(x: 188, y: -97.5001),
                      control1: CGPoint(x: 42.3333, y: 17.5),
                      control2: CGPoint(x: 54, y: -73.5001))
        path.addCurve(to: CGPoint(x: 237.5, y: 19.4999),
                      control1: CGPoint(x: 355.5, y: -127.5),
                      control2: CGPoint(x: 235, y: -96.5001))
        path.addCurve(to: CGPoint(x: 380.5, y: 183.5),
                      control1: CGPoint(x: 240, y: 135.5),
                      control2: CGPoint(x: 284, y: 117))
        path.addCurve(to: CGPoint(x: 247.5, y: 366),
                      control1: CGPoint(x: 477, y: 250),
                      control2: CGPoint(x: 311.5, y: 383.5))
        path.addCurve(to: CGPoint(x: 237.5, y: 223),
                      control1: CGPoint(x: 183.5, y: 348.5),
                      control2: CGPoint(x: 222.5, y: 351.5))
        path.closeSubpath()
        return path
    }
}
struct RED: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: x / 218 * width, y: y / 406 * height)
        }

        var path = Path()
        path.move(to: point(133.115, 388.391))
        path.addCurve(to: point(153, 65),
                      control1: point(75.5416, 303.957),
                      control2: point(122.383, 137.616))
        path.addLine(to: point(153, 65))
        path.addCurve(to: point(12.8552, 208.429),
                      control1: point(146.372, 65),
                      control2: point(109.063, 93.6857))
        path.addCurve(to: point(133.115, 388.391),
                      control1: point(-107.404, 351.857),
                      control2: point(205.081, 493.933))
        path.closeSubpath()
        return path
    }
}
struct GREEN: Shape {
    func path(in rect: CGRect) -> Path {
           let width = rect.width
           let height = rect.height

           func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
               CGPoint(x: x / 430 * width, y: y / 932 * height)
           }

           var path = Path()
           path.move(to: point(218.326, 87.3249))
           path.addCurve(to: point(-12.6738, 151.325),
                         control1: point(158.726, -26.2751),
                         control2: point(39.4929, 82.6582))
           path.addCurve(to: point(-23.1738, 232.825),
                         control1: point(-29.1738, 155.992),
                         control2: point(-54.3738, 178.825))
           path.addCurve(to: point(147.326, 151.325),
                         control1: point(15.8262, 300.325),
                         control2: point(93.8262, 101.325))
           path.addCurve(to: point(157.826, 395.825),
                         control1: point(200.826, 201.325),
                         control2: point(37.3262, 275.325))
           path.addCurve(to: point(93.8262, 654.825),
                         control1: point(278.326, 516.325),
                         control2: point(108.326, 484.325))
           path.addCurve(to: point(317.326, 981.325),
                         control1: point(79.3262, 825.325),
                         control2: point(86.8262, 1005.82))
           path.addCurve(to: point(200.326, 853.325),
                         control1: point(547.826, 956.825),
                         control2: point(356.326, 874.825))
           path.addCurve(to: point(395.326, 523.825),
                         control1: point(44.3262, 831.825),
                         control2: point(281.826, 711.325))
           path.addCurve(to: point(218.326, 349.825),
                         control1: point(508.826, 336.325),
                         control2: point(317.326, 456.325))
           path.addCurve(to: point(218.326, 87.3249),
                         control1: point(119.326, 243.325),
                         control2: point(292.826, 229.325))
           path.closeSubpath()
           return path
       }
}

struct CYAN: Shape {
    func path(in rect: CGRect) -> Path {
            let width = rect.width
            let height = rect.height

            // Offset para transformar o conteúdo negativo para dentro do viewBox
            // A bounding box original vai de x: -228 a 82 (span de ~310), y: ~0 a ~435
            // Vamos aplicar um offset para trazer tudo proporcionalmente ao rect

            func normalizeX(_ x: CGFloat) -> CGFloat {
                // Mapeando de (-228...82) para (0...1)
                return (x + 228) / 310
            }

            func normalizeY(_ y: CGFloat) -> CGFloat {
                // Mapeando de (0...435) para (0...1)
                return y / 435
            }

            func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
                CGPoint(x: normalizeX(x) * width,
                        y: normalizeY(y) * height)
            }

            var path = Path()
            path.move(to: point(26.4839, 186.608))
            path.addCurve(to: point(-227.993, 14.8098),
                          control1: point(82.1508, 34.4916),
                          control2: point(-119.973, 8.69403))
            path.addCurve(to: point(-200.159, 383.426),
                          control1: point(-251.187, 104.879),
                          control2: point(-278.093, 304.699))
            path.addCurve(to: point(26.4839, 186.608),
                          control1: point(-102.743, 481.835),
                          control2: point(-43.0995, 376.754))
            path.closeSubpath()
            return path
        }
}
struct BLUE: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: x / 274 * width, y: y / 453 * height)
        }

        var path = Path()
        path.move(to: point(44.8124, 344.553))
        path.addCurve(to: point(307.103, 469),
                      control1: point(11.3494, 462.878),
                      control2: point(169.086, 490.078))
        path.addLine(to: point(307.103, 203.607))
        path.addCurve(to: point(296.5, 40.5001),
                      control1: point(354.304, 59.7377),
                      control2: point(435.612, 39.1149))
        path.addCurve(to: point(44.8124, 344.553),
                      control1: point(157.388, 41.8853),
                      control2: point(78.2754, 226.229))
        path.closeSubpath()
        return path
    }
}
