//
//  Copyright (c) 2018. Uber Technologies
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

import ArgumentParser
import Foundation
import TSCUtility
import TSCBasic
import MockoloFramework
import Backtrace

@main
struct Mockolo {
    static func main() {
        Backtrace.install()

        let inputs = Array(CommandLine.arguments.dropFirst())
        if let arg = inputs.first, (arg == "--version" || arg == "-v") {
            print(Version.current.value)
            return
        }

        Executor.main(inputs)
    }
}
