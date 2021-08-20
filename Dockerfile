#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["JenkinsProject.Demo/JenkinsProject.Demo.csproj", "JenkinsProject.Demo/"]
RUN dotnet restore "JenkinsProject.Demo/JenkinsProject.Demo.csproj"
COPY . .
WORKDIR "/src/JenkinsProject.Demo"
RUN dotnet build "JenkinsProject.Demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "JenkinsProject.Demo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "JenkinsProject.Demo.dll"]