//
//  NVM_MPSettings.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI


// MARK: - NVM_MPSettings
public struct NVM_MPSettings<Footer: View>: View {
    private let settingLinks: [NVM_MPSettingsLink]
    
    private let accent: Color
    private let color: Bool
    private let title: String
    private let project: String
    
    private let footer: Footer?
    
    private let sectionizedSettingLinks: Array<(key: SettingsSection, value: Array<NVM_MPSettingsLink>)>
    private let sectionizedSettingLinksDict: [SettingsSection : [NVM_MPSettingsLink]]
    private let settingSections: [SettingsSection]
    
    @State private var selection: NVM_MPSettingsLink? = nil
    @State private var lastSection: String? = nil
    
    @Environment(\.openURL) var openURL
    
    public init(settingLinks: [NVM_MPSettingsLink],
                accent: Color,
                color: Bool = true,
                title: String = "Settings",
                project: String,
                footer: Footer? = nil) {
        self.settingLinks = settingLinks
        self.accent = accent
        self.color = color
        self.title = title
        self.project = project
        self.footer = footer
        
        self.sectionizedSettingLinks = sectionized(settingLinks)
        self.sectionizedSettingLinksDict = Dictionary(uniqueKeysWithValues: sectionizedSettingLinks)
        self.settingSections = settingsSections(from: sectionizedSettingLinks)
    }
    
    public var body: some View {
        #if os(macOS)
        VStack {
            if let selection = selection {
                selection.getDestination
            } else {
                Text("\(project.capitalized) preferences")
            }
        }
        .nvm_mpFrame(.settings)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                ForEach(settingLinks) { settingLink in
                    Button(action: {
                        switch settingLink.destinationType {
                        case .view:
                            self.selection = settingLink
                        case .url:
                            openURL(settingLink.getURL)
                        }
                    }) {
                        SettingsRow(settingLink, accent: accent, color: color, selection: $selection)
                    }
                    .buttonStyle(.borderless)
                    .onAppear {
                        if settingLinks.first?.id == settingLink.id {
                            self.selection = settingLink
                        }
                    }
                }
            }
        }
        #else
        if #available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *) {
            NavigationStack {
                List {
                    ForEach(settingSections) { settingSection in
                        let sectionSettingLinks = sectionizedSettingLinksDict[settingSection]!
                        NVM_MPSettingsSection(settingSection: settingSection,
                                              sectionSettingLinks: sectionSettingLinks,
                                              accent: accent,
                                              color: color,
                                              selection: $selection)
                    }
                    if let footer {
                        footer
                    }
                }
                .navigationDestination(for: NVM_MPSettingsLink.self) { settingLink in
                    settingLink.getDestination
                        .nvm_mpNavigationTitle(settingLink.text, mode: .inline)
                }
                .nvm_mpNavigationTitle(title)
            }
        } else {
            NavigationView {
                List {
                    ForEach(settingSections) { settingSection in
                        let sectionSettingLinks = sectionizedSettingLinksDict[settingSection]!
                        NVM_MPSettingsSection(settingSection: settingSection,
                                              sectionSettingLinks: sectionSettingLinks,
                                              accent: accent,
                                              color: color,
                                              selection: $selection)
                    }
                    if let footer {
                        footer
                    }
                }
                .nvm_mpNavigationTitle(title)
            }
        }
        #endif
    }
}

public struct NVM_MPSettingsSection : View {
    let settingSection: SettingsSection?
    let sectionSettingLinks: [NVM_MPSettingsLink]
    
    let accent: Color
    let color: Bool
    
    @Binding var selection: NVM_MPSettingsLink?
    @Environment(\.openURL) var openURL
    
    public var body: some View {
        if let section = settingSection?.section {
            Section(header: Text(section)) {
                ForEach(sectionSettingLinks) { settingLink in
                    switch settingLink.destinationType {
                    case .view:
                        if #available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *) {
                            NavigationLink(value: settingLink) {
                                SettingsRow(settingLink, accent: accent, color: color, selection: $selection)
                            }
                        } else {
                            NavigationLink {
                                settingLink.getDestination
                                    .nvm_mpNavigationTitle(settingLink.text, mode: .inline)
                            } label: {
                                SettingsRow(settingLink, accent: accent, color: color, selection: $selection)
                            }
                        }
                    case .url:
                        Button {
                            openURL(settingLink.getURL)
                        } label: {
                            SettingsRow(settingLink, accent: accent, color: color, selection: $selection)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        } else {
            ForEach(sectionSettingLinks) { settingLink in
                switch settingLink.destinationType {
                case .view:
                    if #available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *) {
                        NavigationLink(value: settingLink) {
                            SettingsRow(settingLink, accent: accent, color: color, selection: $selection)
                        }
                    } else {
                        NavigationLink {
                            settingLink.getDestination
                                .nvm_mpNavigationTitle(settingLink.text, mode: .inline)
                        } label: {
                            SettingsRow(settingLink, accent: accent, color: color, selection: $selection)
                        }
                    }
                case .url:
                    Button {
                        openURL(settingLink.getURL)
                    } label: {
                        SettingsRow(settingLink, accent: accent, color: color, selection: $selection)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}


fileprivate struct SettingsRow: View {
    let settingLink: NVM_MPSettingsLink
    let accent: Color
    let color: Bool
    
    @Binding private var selection: NVM_MPSettingsLink?
    
    init(_ settingLink: NVM_MPSettingsLink, accent: Color, color: Bool, selection: Binding<NVM_MPSettingsLink?>) {
        self.settingLink = settingLink
        self.accent = accent
        self.color = color
        
        self._selection = selection
    }
    
    var body: some View {
        ZStack {
            if NVMmacOS {
                if selected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary)
                        .opacity(0.1)
                }
                VStack(spacing: 0) {
                    ZStack {
                        let tint = color ? (selected ? settingLink.tint ?? accent : settingLink.tint) : Color.secondary
                        ZStack {
                            Circle()
                                .fill(tint ?? accent)
                                .foregroundColor(tint ?? accent)
                                .accentColor(tint ?? accent)
                                .frame(width: 22, height: 22)
                            if (tint == .gray || !color) {
                                Circle()
                                    .fill(Color.black)
                                    .foregroundColor(Color.black)
                                    .accentColor(Color.black)
                                    .frame(width: 22, height: 22)
                                    .opacity(0.4)
                            }
                        }
                        if let systemImage = settingLink.systemImage {
                            Image(systemName: systemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .font(.system(size: 8))
                                .foregroundColor(Color.white)
                                .accentColor(Color.white)
                        } else if let image = settingLink.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 0.5))
                                .frame(width: 25, height: 25)
                        } else {
                            settingLink.getView
                                .frame(width: 20, height: 20)
                        }
                    }
                    Spacer()
                        .frame(height: 2)
                    Text(settingLink.text)
                        .foregroundColor(selected ? (settingLink.tint ?? accent) : Color.secondary)
                        .font(.system(size: 10))
                    }
                .offset(y: 1.5)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
            } else {
                HStack {
                    ZStack {
                        let tint = color ? settingLink.tint : Color.secondary
                        ZStack {
                            Circle()
                                .fill(tint ?? accent)
                                .foregroundColor(tint ?? accent)
                                .accentColor(tint ?? accent)
                                .frame(width: 25, height: 25)
                            if (tint == .gray || !color) {
                                Circle()
                                    .fill(Color.black)
                                    .foregroundColor(Color.black)
                                    .accentColor(Color.black)
                                    .frame(width: 25, height: 25)
                                    .opacity(0.4)
                            }
                        }
                        if let systemImage = settingLink.systemImage {
                            Image(systemName: systemImage)
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 10))
                                .foregroundColor(Color.white)
                                .accentColor(Color.white)
                                .frame(width: 12, height: 12)
                        } else if let image = settingLink.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 0.5))
                                .frame(width: 25, height: 25)
                        } else {
                            settingLink.getView
                                .frame(width: 20, height: 20)
                        }
                    }
                    Text(settingLink.text)
                    Spacer()
                }
            }
        }
    }
    
    private var selected: Bool {
        guard let selection = selection else { return false }
        
        return selection.id == settingLink.id
    }
}

public struct NVM_MPSettingsLink: Identifiable {
    
    let destination: NVMSettingsDestination
    let text: String
    let systemImage: String?
    let image: Image?
    let view: (any View)?
    
    let tint: Color?
    let section: SettingsSection
    let frame: NVM_MPFrame?
    
    public let id: String
    
    @State private var showSheet: Bool = false
    
    public init(_ destination: NVMSettingsDestination, text: String, systemImage: String,
                tint: Color? = nil, section: SettingsSection, frame: NVM_MPFrame? = nil,
                id: String = UUID().uuidString) {
        self.destination = destination
        self.text = text
        self.systemImage = systemImage
        self.image = nil
        self.view = nil
        
        self.tint = tint
        self.section = section
        self.frame = frame
        
        self.id = id
    }
    public init(_ destination: NVMSettingsDestination, text: String, systemImage: String,
                tint: Color? = nil, frame: NVM_MPFrame? = nil,
                id: String = UUID().uuidString) {
        self.destination = destination
        self.text = text
        self.systemImage = systemImage
        self.image = nil
        self.view = nil
        
        self.tint = tint
        self.section = SettingsSection()
        self.frame = frame
        
        self.id = id
    }
    
    public init(_ destination: NVMSettingsDestination, text: String, image: Image?,
                tint: Color? = nil, section: SettingsSection, frame: NVM_MPFrame? = nil,
                id: String = UUID().uuidString) {
        self.destination = destination
        self.text = text
        self.systemImage = nil
        self.image = image
        self.view = nil
        
        self.tint = tint
        self.section = section
        self.frame = frame
        
        self.id = id
    }
    public init(_ destination: NVMSettingsDestination, text: String, image: Image?,
                tint: Color? = nil, frame: NVM_MPFrame? = nil,
                id: String = UUID().uuidString) {
        self.destination = destination
        self.text = text
        self.systemImage = nil
        self.image = image
        self.view = nil
        
        self.tint = tint
        self.section = SettingsSection()
        self.frame = frame
        
        self.id = id
    }
    
    public init(_ destination: NVMSettingsDestination, text: String, view: any View,
                tint: Color? = nil, section: SettingsSection, frame: NVM_MPFrame? = nil,
                id: String = UUID().uuidString) {
        self.destination = destination
        self.text = text
        self.systemImage = nil
        self.image = nil
        self.view = view
        
        self.tint = tint
        self.section = section
        self.frame = frame
        
        self.id = id
    }
    public init(_ destination: NVMSettingsDestination, text: String, view: any View,
                tint: Color? = nil, frame: NVM_MPFrame? = nil,
                id: String = UUID().uuidString) {
        self.destination = destination
        self.text = text
        self.systemImage = nil
        self.image = nil
        self.view = view
        
        self.tint = tint
        self.section = SettingsSection()
        self.frame = frame
        
        self.id = id
    }
    
    internal var destinationType: NVMSettingsDestination.DestinationType {
        return self.destination.type
    }
    
    @ViewBuilder internal var getDestination: some View {
        if self.destinationType == .view {
            if let destination = self.destination.destination {
                ZStack {
                    AnyView(destination)
                }
            } else {
                Text("No destination set")
            }
        } else {
            fatalError("Requested View but set as \(self.destinationType)")
        }
    }
    
    internal var getURL: URL {
        if let destinationURLstring = self.destination.url, let destinationURL = URL(string: destinationURLstring), self.destinationType == .url {
            return destinationURL
        } else {
            fatalError("Requested URL but set as \(self.destinationType)")
        }
    }
    
    @ViewBuilder internal var getView: some View {
        if let view = self.view {
            ZStack {
                AnyView(view)
            }
        } else {
            Image(systemName: "exclamationmark.questionmark")
        }
    }
}

extension NVM_MPSettingsLink: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: NVM_MPSettingsLink, rhs: NVM_MPSettingsLink) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct NVMSettingsDestination {
    let type: DestinationType
    let destination: (any View)?
    let url: String?
    
    public init(destination: any View) {
        self.type = .view
        self.destination = destination
        self.url = nil
    }
    
    public init(url: String) {
        self.type = .url
        self.destination = nil
        self.url = url
    }
    
    public enum DestinationType {
        case view
        case url
    }
}

public struct SettingsSection: Hashable, Identifiable {
    public var id: String { UUID().uuidString }
    
    public var type: SectionType
    public var custom: String?
    
    public init() {
        self.type = .empty
    }
    
    public init(type: SectionType) {
        self.type = type
        self.custom = nil
    }
    
    public init(custom: String) {
        self.type = .custom
        self.custom = custom
    }
    
    internal var section: String? {
        switch self.type {
        case .custom:
            if let customSection = custom {
                return customSection
            } else {
                return ""
            }
        case .empty:
            return nil
        default:
            return self.type.rawValue
        }
    }
    
    public enum SectionType: String {
        case custom
        case empty
        
        case Advanced
        case General
        case Novem
    }
}

public protocol NVMSettingsView: View {
}

func settingsSections(from dictionary: Array<(key: SettingsSection, value: Array<NVM_MPSettingsLink>)>) -> [SettingsSection] {
    return dictionary.map { $0.key }
}

fileprivate func sectionized(_ settingLinks: [NVM_MPSettingsLink]) -> Array<(key: SettingsSection, value: Array<NVM_MPSettingsLink>)> {
    var tempSectionizedSettingLinks: [SettingsSection : [NVM_MPSettingsLink]] = [:]
    for settingLink in settingLinks {
        var sectionSettingLinks = tempSectionizedSettingLinks[settingLink.section] ?? []
        sectionSettingLinks.append(settingLink)
        
        tempSectionizedSettingLinks[settingLink.section] = sectionSettingLinks
    }
    
    let sections = settingLinks.map { $0.section }
    return tempSectionizedSettingLinks.sorted(by: {
        guard let first = sections.firstIndex(of: $0.key) else { return false }
        guard let second = sections.firstIndex(of: $1.key) else { return true }

        return first < second
    })
}


// MARK: - NVM_MPSettingsButtonStyle
public struct NVM_MPSettingsButtonStyle: ViewModifier {
    #if os(iOS)
    public func body(content: Content) -> some View {
        content
            .buttonStyle(.plain)
    }
    #else
    public func body(content: Content) -> some View {
        content
    }
    #endif
}
public extension Button {
    func nvm_mpSettingsButtonStyle() -> some View {
        self.modifier(NVM_MPSettingsButtonStyle())
    }
}

/*
struct NVM_MPSettingsPreviews : PreviewProvider {
    
    static var previews: some View {
        let settingsLinks = [
            NVM_MPSettingsLink(NVMSettingsDestination(destination: Text("Selections")),
                               text: "Selections",
                               systemImage: "checkmark.rectangle.portrait.fill",
                               tint: .accentColor,
                               section: SettingsSection(type: .General)),
            NVM_MPSettingsLink(NVMSettingsDestination(destination: Text("Test")),
                               text: "Test label",
                               systemImage: "arkit",
                               tint: .blue,
                               section: SettingsSection(custom: "Test")),
            NVM_MPSettingsLink(NVMSettingsDestination(destination: Text("Layout")),
                               text: "Layout",
                               systemImage: "paintbrush",
                               tint: .green),
            NVM_MPSettingsLink(NVMSettingsDestination(destination: Text("Geavanceerd")),
                               text: "Geavanceerd",
                               systemImage: "gear",
                               tint: .gray,
                               section: SettingsSection(type: .Advanced))
        ]
        
        NVM_MPSettings(settingLinks: settingsLinks, nvmAuthentication: ObservedObject(initialValue: NVMAuthentication()), accent: .accentColor, color: true)
    }
}
*/
