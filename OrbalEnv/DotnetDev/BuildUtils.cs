// File: BuildUtils.cs

using System;
using System.Collections.Generic;

internal static class BuildUtils
{
    /// <summary>
    /// </summary>
    public static void ProcessBuildArg(string paramName,
                                       string argValue,
                                       Dictionary<string, string> processedArgs,
                                       bool isConfigParam)
    {
        if (isConfigParam)
            ProcessBuildConfigArg(ref argValue);

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

    /// <summary>
    /// </summary>
    /// <returns>
    /// </returns>
    public static bool IsTestArgDuplicated(string paramName,
                                           string argValue,
                                           Dictionary<string, string> kvpArgs,
                                           List<string> otherArgs)
    {
        return (kvpArgs.ContainsKey(paramName)
                || !string.IsNullOrEmpty(
                    otherArgs.Find(
                        x => x.ToLower().Contains(argValue.ToLower()))));
    }

    private static void ProcessBuildConfigArg(ref string configValue)
    {
        if (string.IsNullOrEmpty(configValue) || configValue == "dbg")
            configValue = "Debug";
        else if (configValue == "chk")
            configValue = "Checked";
        else if (configValue == "rel")
            configValue = "Release";
    }
}
