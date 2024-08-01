// File: CommandsModule.cs

using System;
using System.Runtime.InteropServices;

internal static class CommandsModule
{
    public static int GetArch()
    {
        Architecture arch = RuntimeInformation.OSArchitecture;
        Console.WriteLine(arch.ToString().ToLower());
        return 0;
    }

    public static int GetOS()
    {
        string os = "other";

        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            os = "windows";
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            os = "osx";
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            os = "linux";
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.FreeBSD))
            os = "freebsd";

        Console.WriteLine(os);
        return 0;
    }
}
