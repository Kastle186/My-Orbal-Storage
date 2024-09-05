// File: Commands.cs

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class DotnetDevCommands
{
    // PLANS:
    // Parse the command line. We can defer faulty command-lines to be handled
    // by the runtime repo's build script, so here, we'll just assume they're
    // well-formed.

    static readonly string s_scriptExt = OperatingSystem.IsWindows() ? ".cmd" : ".sh";
}
