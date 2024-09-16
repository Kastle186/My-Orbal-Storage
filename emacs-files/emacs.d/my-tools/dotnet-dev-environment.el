;; ******************************
;; Dotnet Development Environment
;; ******************************

(define-skeleton dotnet-project-template
  "Generate a basic template for a dotnet C# project. This is basically mostly
copying what 'dotnet new console' does, but without all the extra stuff we don't
use and end up deleting."
  ""
  > "<Project Sdk=\"Microsoft.NET.Sdk\">" \n
  > "<PropertyGroup>" \n
  > "<OutputType>Exe</OutputType>" \n
  > "<TargetFramework>net9.0</TargetFramework>" \n
  > "</PropertyGroup>" \n
  > "</Project>")

(define-skeleton csharp-app-template
  "Generate a basic template for a C# file with a main method. This means, add
the 'using System;' statement, as well as the class that will contain the main
method. Also, then add an empty main method that returns an int and receives
a 'string[] args' as parameter.

Basically, do what 'dotnet new console' does, but correctly, like it used to do.
It's annoying how it cuts corners with the 'Implicit Usings' in an attempt of
simplicity but doesn't give an option to opt in or out of that behavior."
  ""
  "using System;" \n
  \n
  "public class " (skeleton-read "Enter the class's name: ") \n
  "{" \n
  "static int Main(string[] args)" \n
  "{" \n
  "return 0;" \n
  "}" \n
  "}" \n)
