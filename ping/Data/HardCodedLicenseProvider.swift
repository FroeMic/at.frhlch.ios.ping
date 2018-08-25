//
//  File.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

class HardCodedLicenseProvider: LicenseProvider {
    
    let licenses: [License] = [
        License(title: "Appirater",
                url: "https://github.com/arashpayan/appirater/",
                license:
                """
                Copyright 2017. [Arash Payan] arash. This library is distributed under the terms of the MIT/X11.

                While not required, I greatly encourage and appreciate any improvements that you make to this library be contributed back for the benefit of all who use Appirater.
                """),
        License(title: "Siren",
                url: "https://github.com/ArtSabintsev/Siren",
                license:
                """
                The MIT License (MIT)

                Copyright (c) 2015 Arthur Ariel Sabintsev

                Permission is hereby granted, free of charge, to any person obtaining a copy
                of this software and associated documentation files (the "Software"), to deal
                in the Software without restriction, including without limitation the rights
                to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                copies of the Software, and to permit persons to whom the Software is
                furnished to do so, subject to the following conditions:

                The above copyright notice and this permission notice shall be included in all
                copies or substantial portions of the Software.

                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                SOFTWARE.
                """),
        License(title: "GBPing",
                url: "https://github.com/lmirosevic/GBPing",
                license:
                """
                Copyright 2015 Luka Mirosevic

                Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

                http://www.apache.org/licenses/LICENSE-2.0

                Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
                """),
        License(title: "SwiftyStoreKit",
                url: "https://github.com/bizz84/SwiftyStoreKit",
                license:
                """
                Copyright (c) 2015-2016 Andrea Bizzotto bizz84@gmail.com

                Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

                The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                """),
        License(title: "Kvitto",
                url: "https://github.com/Cocoanetics/Kvitto",
                license:
                """
                Copyright (c) 2015, Oliver Drobnik All rights reserved.

                Redistribution and use in source and binary forms, with or without
                modification, are permitted provided that the following conditions are met:

                - Redistributions of source code must retain the above copyright notice, this
                  list of conditions and the following disclaimer.

                - Redistributions in binary form must reproduce the above copyright notice,
                  this list of conditions and the following disclaimer in the documentation
                  and/or other materials provided with the distribution.

                THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
                AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
                IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
                DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
                FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
                DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
                SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
                CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
                OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
                OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
                """),
        License(title: "Icons8",
                url: "https://icons8.com/",
                license:
            """
                The icons, sounds, and photos are free for personal use and also free for commercial use, but we require linking to our web site. We distribute them under the license called Creative Commons Attribution-NoDerivs 3.0 Unported. Alternatively, you could buy a license that doesn't require any linking.
                """),
    ]
    
}
