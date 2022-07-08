//
//  Copyright (c) 2022. natinusala
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import PackagePlugin

@main
struct MockoloPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // XXX: `fatalError` instead of throwing an error since regular errors do not interrupt the building
        // process for some reason?
        guard let tool = try? context.tool(named: "Mockolo") else { fatalError("Could not find Mockolo tool") }

        // Take all Swift dependencies of the target and make a command to run `mockolo` on them (not recursive)
        return target.dependencies.compactMap { (dependency) -> Command? in
            guard let dependency = dependency.target as? SwiftSourceModuleTarget else { return nil }

            let output = context.pluginWorkDirectory.appending("\(dependency.name)_MockoloMocks.swift")

            return .buildCommand(
                displayName: "Generating mocks for \(target.name)",
                executable: tool.path,
                arguments: [
                    // Input
                    "--sourcedirs",
                    dependency.directory,
                    // Output
                    "--destination",
                    output.string,
                    // Add `@testable import` to the original target
                    "--testable-imports",
                    dependency.name,
                    // // Set verbosity to `warning`
                    "-l",
                    "2",
                ],
                inputFiles: dependency.sourceFiles.map { $0.path },
                outputFiles: [output]
            )
        }
    }
}

extension TargetDependency {
    var target: Target? {
        switch self {
        case let .target(target):
            return target
        default:
            return nil
        }
    }
}
