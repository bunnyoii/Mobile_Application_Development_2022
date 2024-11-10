# VisionOS

## 项目名称

VisionOS | 个人介绍应用

## 项目演示

![](Demonstration.gif)

## 项目 MVVM（Model-View-ViewModel）设计模式架构

World 项目使用了 MVVM（Model-View-ViewModel）设计模式。

### Model（模型）

在 MVVM 设计模式中，Model 层负责管理和存储应用数据，而 Module 枚举则定义了应用中各个模块的信息和相关数据。

**核心数据管理**：Module 枚举用于描述应用内不同模块（如 globe、orbit、solar、about），并为每个模块提供必要的元数据，包括标题（heading）、简介（abstract）、操作提示（callToAction）等。这些信息直接为视图所用，因此归属于 Model 层。

**静态数据的存储**：Module 枚举的主要作用是存储模块的静态数据，例如模块名称、描述和用户交互内容。这些数据在应用中变化频率低，但对模块功能和界面内容起关键作用。与 ViewModel 中动态管理的状态数据不同，它更注重模块结构和内容的定义。

**数据流转在 MVVM 中的角色**：在 MVVM 模式中，ViewModel 作为连接视图和模型的中介，从模型中提取数据并将其提供给视图层。Module 中定义的静态信息通过 ViewModel 流向视图，最终用于渲染 UI，确保数据和界面同步。

#### Model 层的调整

- `Module.swift`：在 Module 枚举中新增了 about 模块，并为其定义了多个属性，包括 eyebrow、heading、abstract、overview 和 callToAction。这些属性为模块提供详细描述和用户交互选项，增强了模块的可展示性。

- `ModuleCard.swift`：新增了一行代码 ModuleCard(module: .about)，将 about 模块集成到模块卡片视图中，确保用户可以在界面中看到并操作该模块。

- `ModuleDetail.swift`：扩展了 ModuleDetail 视图，支持在 about 模块被选中时显示特定组件 AboutMeToggle。此外，模块详情逻辑中增加了 AboutMeModule 的内容渲染支持。

- `Modules.swift`：在模块关闭逻辑中加入了 `model.isShowingAboutMe`，确保 about 模块在退出沉浸式模式时能够正确关闭，与其他模块保持一致的用户体验。

### View（视图）
在 MVVM 设计模式中，`View` 层负责呈现用户界面并处理用户交互。通过绑定 `ViewModel`，`View` 层可以响应数据变化并更新界面。

- **模块化视图设计**：视图层采用模块化组件来提升代码的可维护性与复用性，例如 `AboutMe`、`AboutMeModule` 和 `AboutMeToggle`。这些组件各自承担特定的视图渲染任务，并通过与 `ViewModel` 的绑定动态更新界面。

- **自定义视频播放器**：为了在 `SwiftUI` 环境中实现视频播放，创建了 `CustomVideoPlayer`，它封装了 `UIKit` 的 `AVPlayer`，并借助 `UIViewRepresentable` 将其集成到 `SwiftUI` 中，从而实现视图层的无缝扩展。

- **交互控制与资源管理**：通过视图组件如 AboutMeToggle，用户可以在沉浸式场景中自由切换模块，而 `View` 层会根据 `ViewModel` 的状态动态加载或卸载模块资源，确保性能优化。

#### View 层的调整：

- **`AboutMe.swift`**：定义了 `AboutMe` 视图，它通过 `CustomVideoPlayer` 播放视频，并使用 `placementGestures` 方法设置视频初始位置。在视图被移除时，自动更新 `ViewModel` 的 `isShowingAboutMe` 状态。

- **`AboutMeModule.swift`**：`AboutMeModule` 视图用于显示用户标识图片。通过 `GeometryReader` 确保图片在不同设备上自适应，始终居中且比例合适。

- **`AboutMeToggle.swift`**：提供一个开关组件，用于控制 `About Me` 模块的显示状态。`Toggle` 会监听 `ViewModel` 的 `isShowingAboutMe` 状态，并在切换时异步打开或关闭沉浸式场景，优化资源管理。

#### View 层组件的具体实现

- **AboutMe**：负责播放自我介绍视频，使用 `CustomVideoPlayer` 嵌入视频播放器，并通过 `onDisappear` 方法在视图消失时释放资源。

- **AboutMeModule**：展示用户的标识图片，使用 `resizable` 和 `scaledToFit` 实现图像的自适应布局，保证良好的跨设备视觉体验。

- **AboutMeToggle**：用于在沉浸式场景中切换 `About Me` 模块状态。`Toggle` 组件绑定 `ViewModel` 中的 `isShowingAboutMe` 状态，确保 UI 与逻辑同步。

### ViewModel（视图模型）

在 MVVM 设计模式中，ViewModel 负责连接视图和模型，管理数据及状态逻辑。它从模型层获取数据并提供给视图，同时接收用户交互并更新应用状态。

**导航与标题管理**：
ViewModel 通过 `navigationPath` 记录用户的导航历史，并使用 `titleText` 和 `finalTitle` 来管理应用的标题显示状态。`isTitleFinished` 则用来指示标题动画或显示过程是否完成。

**模块状态管理**：
ViewModel 对每个模块的显示状态进行独立管理，通过布尔值变量（如 `isShowingGlobe、isShowingOrbit、isShowingSolar、isShowingAboutMe`）来控制各模块的显示或隐藏，确保视图的动态更新与模块切换。

**地球与卫星配置**：
在地球和卫星的各个场景（如 Globe、Orbit、Solar System）中，ViewModel 提供了相应的配置对象，用于定义场景中地球、卫星和其他实体的初始状态及动态更新。包括：

`globeEarth`：地球在 `Globe` 模块中的配置。
`orbitEarth、orbitSatellite、orbitMoon`：Orbit 模块中地球、卫星、月球的配置。
`solarEarth、solarSatellite、solarMoon`：Solar System 模块中地球、卫星和月球的配置。

**太阳位置与距离管理**：
`Solar` 模块中，`solarSunDistance` 用于定义太阳与地球的距离，而 `solarSunPosition` 计算并返回太阳在 3D 空间中的位置，以便视图层渲染准确的太阳位置。

**About Me 模块状态**：
`ViewModel` 通过 `isShowingAboutMe` 控制 `About Me` 模块的显示状态，与用户交互直接相关。

#### ViewModel 层的调整

**导航与标题**：通过 `navigationPath` 实现模块间导航历史的跟踪；使用 `titleText` 和 `finalTitle` 提供动态标题内容。

**模块控制**：增加了 `isShowingAboutMe` 状态变量，确保 `About Me` 模块的显示逻辑与其他模块一致。

**3D 场景数据**：提供太阳、地球、卫星在不同模块中的初始配置，支持视图层动态渲染。