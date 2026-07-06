import AppKit
import Foundation

struct IconSlot {
    let idiom: String
    let size: String
    let scale: String
    let filename: String
    let pixels: Int
    let role: String?
    let subtype: String?
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let assets = root.appendingPathComponent("Resources/Assets.xcassets")
let appIconSet = assets.appendingPathComponent("AppIcon.appiconset")
let previewSet = assets.appendingPathComponent("AppIconPreview.imageset")
let accentSet = assets.appendingPathComponent("AccentColor.colorset")

try FileManager.default.createDirectory(at: appIconSet, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: previewSet, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: accentSet, withIntermediateDirectories: true)

let slots: [IconSlot] = [
    IconSlot(idiom: "iphone", size: "20x20", scale: "2x", filename: "AppIcon-iphone-20@2x.png", pixels: 40, role: nil, subtype: nil),
    IconSlot(idiom: "iphone", size: "20x20", scale: "3x", filename: "AppIcon-iphone-20@3x.png", pixels: 60, role: nil, subtype: nil),
    IconSlot(idiom: "iphone", size: "29x29", scale: "2x", filename: "AppIcon-iphone-29@2x.png", pixels: 58, role: nil, subtype: nil),
    IconSlot(idiom: "iphone", size: "29x29", scale: "3x", filename: "AppIcon-iphone-29@3x.png", pixels: 87, role: nil, subtype: nil),
    IconSlot(idiom: "iphone", size: "40x40", scale: "2x", filename: "AppIcon-iphone-40@2x.png", pixels: 80, role: nil, subtype: nil),
    IconSlot(idiom: "iphone", size: "40x40", scale: "3x", filename: "AppIcon-iphone-40@3x.png", pixels: 120, role: nil, subtype: nil),
    IconSlot(idiom: "iphone", size: "60x60", scale: "2x", filename: "AppIcon-iphone-60@2x.png", pixels: 120, role: nil, subtype: nil),
    IconSlot(idiom: "iphone", size: "60x60", scale: "3x", filename: "AppIcon-iphone-60@3x.png", pixels: 180, role: nil, subtype: nil),
    IconSlot(idiom: "ipad", size: "20x20", scale: "1x", filename: "AppIcon-ipad-20.png", pixels: 20, role: nil, subtype: nil),
    IconSlot(idiom: "ipad", size: "20x20", scale: "2x", filename: "AppIcon-ipad-20@2x.png", pixels: 40, role: nil, subtype: nil),
    IconSlot(idiom: "ipad", size: "29x29", scale: "1x", filename: "AppIcon-ipad-29.png", pixels: 29, role: nil, subtype: nil),
    IconSlot(idiom: "ipad", size: "29x29", scale: "2x", filename: "AppIcon-ipad-29@2x.png", pixels: 58, role: nil, subtype: nil),
    IconSlot(idiom: "ipad", size: "40x40", scale: "1x", filename: "AppIcon-ipad-40.png", pixels: 40, role: nil, subtype: nil),
    IconSlot(idiom: "ipad", size: "40x40", scale: "2x", filename: "AppIcon-ipad-40@2x.png", pixels: 80, role: nil, subtype: nil),
    IconSlot(idiom: "ipad", size: "76x76", scale: "1x", filename: "AppIcon-ipad-76.png", pixels: 76, role: nil, subtype: nil),
    IconSlot(idiom: "ipad", size: "76x76", scale: "2x", filename: "AppIcon-ipad-76@2x.png", pixels: 152, role: nil, subtype: nil),
    IconSlot(idiom: "ipad", size: "83.5x83.5", scale: "2x", filename: "AppIcon-ipad-83.5@2x.png", pixels: 167, role: nil, subtype: nil),
    IconSlot(idiom: "ios-marketing", size: "1024x1024", scale: "1x", filename: "AppIcon-1024.png", pixels: 1024, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "16x16", scale: "1x", filename: "AppIcon-mac-16.png", pixels: 16, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "16x16", scale: "2x", filename: "AppIcon-mac-16@2x.png", pixels: 32, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "32x32", scale: "1x", filename: "AppIcon-mac-32.png", pixels: 32, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "32x32", scale: "2x", filename: "AppIcon-mac-32@2x.png", pixels: 64, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "128x128", scale: "1x", filename: "AppIcon-mac-128.png", pixels: 128, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "128x128", scale: "2x", filename: "AppIcon-mac-128@2x.png", pixels: 256, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "256x256", scale: "1x", filename: "AppIcon-mac-256.png", pixels: 256, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "256x256", scale: "2x", filename: "AppIcon-mac-256@2x.png", pixels: 512, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "512x512", scale: "1x", filename: "AppIcon-mac-512.png", pixels: 512, role: nil, subtype: nil),
    IconSlot(idiom: "mac", size: "512x512", scale: "2x", filename: "AppIcon-mac-512@2x.png", pixels: 1024, role: nil, subtype: nil)
]

func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> NSColor {
    NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
}

func drawIcon(size: Int, to url: URL) throws {
    let dimension = CGFloat(size)
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: size,
        pixelsHigh: size,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        throw NSError(domain: "CalmTideIcon", code: 1)
    }

    bitmap.size = NSSize(width: dimension, height: dimension)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    NSGraphicsContext.current?.imageInterpolation = .high

    let rect = NSRect(x: 0, y: 0, width: dimension, height: dimension)
    let background = NSGradient(colors: [
        color(0.02, 0.08, 0.13),
        color(0.02, 0.20, 0.25),
        color(0.10, 0.15, 0.28)
    ])!
    background.draw(in: rect, angle: 90)

    let glow = NSBezierPath(ovalIn: NSRect(x: dimension * 0.46, y: dimension * 0.50, width: dimension * 0.42, height: dimension * 0.42))
    color(0.70, 0.96, 1.0, 0.16).setFill()
    glow.fill()

    let moon = NSBezierPath(ovalIn: NSRect(x: dimension * 0.57, y: dimension * 0.62, width: dimension * 0.18, height: dimension * 0.18))
    color(0.86, 0.98, 1.0, 0.95).setFill()
    moon.fill()

    let cutout = NSBezierPath(ovalIn: NSRect(x: dimension * 0.61, y: dimension * 0.66, width: dimension * 0.16, height: dimension * 0.16))
    color(0.02, 0.13, 0.20, 0.88).setFill()
    cutout.fill()

    let breath = NSBezierPath(ovalIn: NSRect(x: dimension * 0.30, y: dimension * 0.36, width: dimension * 0.40, height: dimension * 0.40))
    color(0.38, 0.91, 0.86, 0.16).setFill()
    breath.fill()
    color(0.77, 1.0, 0.96, 0.34).setStroke()
    breath.lineWidth = max(1, dimension * 0.012)
    breath.stroke()

    func wavePath(offset: CGFloat, height: CGFloat, amplitude: CGFloat) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: NSPoint(x: dimension * 0.13, y: height))
        path.curve(
            to: NSPoint(x: dimension * 0.87, y: height + offset),
            controlPoint1: NSPoint(x: dimension * 0.34, y: height + amplitude),
            controlPoint2: NSPoint(x: dimension * 0.58, y: height - amplitude)
        )
        return path
    }

    let backWave = wavePath(offset: dimension * 0.035, height: dimension * 0.36, amplitude: dimension * 0.13)
    color(0.18, 0.52, 0.75, 0.82).setStroke()
    backWave.lineWidth = max(2, dimension * 0.070)
    backWave.lineCapStyle = .round
    backWave.stroke()

    let frontWave = wavePath(offset: dimension * 0.02, height: dimension * 0.30, amplitude: dimension * 0.10)
    color(0.42, 0.95, 0.88, 0.94).setStroke()
    frontWave.lineWidth = max(2, dimension * 0.052)
    frontWave.lineCapStyle = .round
    frontWave.stroke()

    let bottom = NSBezierPath()
    bottom.move(to: NSPoint(x: 0, y: 0))
    bottom.line(to: NSPoint(x: dimension, y: 0))
    bottom.line(to: NSPoint(x: dimension, y: dimension * 0.25))
    bottom.curve(
        to: NSPoint(x: 0, y: dimension * 0.22),
        controlPoint1: NSPoint(x: dimension * 0.72, y: dimension * 0.17),
        controlPoint2: NSPoint(x: dimension * 0.30, y: dimension * 0.31)
    )
    bottom.close()
    color(0.03, 0.12, 0.19, 0.52).setFill()
    bottom.fill()

    NSGraphicsContext.restoreGraphicsState()

    guard
        let png = bitmap.representation(using: .png, properties: [:])
    else {
        throw NSError(domain: "CalmTideIcon", code: 2)
    }

    try png.write(to: url)
}

for slot in slots {
    try drawIcon(size: slot.pixels, to: appIconSet.appendingPathComponent(slot.filename))
}

try drawIcon(size: 512, to: previewSet.appendingPathComponent("AppIconPreview.png"))

let iconImages = slots.map { slot -> [String: String] in
    var entry = [
        "filename": slot.filename,
        "idiom": slot.idiom,
        "scale": slot.scale,
        "size": slot.size
    ]
    if let role = slot.role {
        entry["role"] = role
    }
    if let subtype = slot.subtype {
        entry["subtype"] = subtype
    }
    return entry
}

func writeJSON(_ object: Any, to url: URL) throws {
    let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
    try data.write(to: url)
}

try writeJSON([
    "images": iconImages,
    "info": ["author": "xcode", "version": 1]
], to: appIconSet.appendingPathComponent("Contents.json"))

try writeJSON([
    "images": [
        ["filename": "AppIconPreview.png", "idiom": "universal", "scale": "1x"]
    ],
    "info": ["author": "xcode", "version": 1]
], to: previewSet.appendingPathComponent("Contents.json"))

let accentJSON = """
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.800",
          "green" : "0.760",
          "red" : "0.180"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""
try accentJSON.data(using: .utf8)?.write(to: accentSet.appendingPathComponent("Contents.json"))

print("Generated CalmTide app icons in \(appIconSet.path)")
