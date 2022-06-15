// Copyright (c) Steve Bush. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using LibraryCodeCoverageBugs;
using Xunit;

public class WindowsCalculatorTests
{
    public WindowsCalculatorTests()
    {
    }

    [Fact]
    public void Windows_AddOrSubtract()
    {
        // This tests aggregation of code coverage across test runs.
#if NETCOREAPP3_1
        Assert.Equal(3, Calculator.Add(1, 2));
#else
        Assert.Equal(-1, Calculator.Subtract(1, 2));
#endif
    }
}
