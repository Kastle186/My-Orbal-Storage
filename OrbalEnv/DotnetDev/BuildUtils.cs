// File: BuildUtils.cs

using System;
using System.Collections.Generic;

internal static class BuildUtils
{
    /// <summary>
    /// </summary>
    public static void ProcessBuildConfigKvpArg(ref string configValue)
    {
        if (string.IsNullOrEmpty(configValue) || configValue == "dbg")
            configValue = "Debug";
        else if (configValue == "chk")
            configValue = "Checked";
        else if (configValue == "rel")
            configValue = "Release";
    }

    /// <summary>
    /// </summary>
    public static void ProcessDashedBuildArg(string paramName,
                                             string argValue,
                                             Dictionary<string, string> processedArgs)
    {
        if (!processedArgs.ContainsKey(paramName))
        {
            processedArgs.Add(paramName, argValue);
        }
        else if (!processedArgs[paramName].Contains(argValue))
        {
            string valToAppend = paramName == "subset" ? $"+{argValue}" : $",{argValue}";
            processedArgs[paramName] += valToAppend;
        }
    }
}
