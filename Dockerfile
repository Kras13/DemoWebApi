FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY DemoWebApi.sln .
COPY DemoWebApi/DemoWebApi.csproj ./DemoWebApi/
RUN dotnet restore

COPY . .
RUN dotnet publish DemoWebApi/DemoWebApi.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:${PORT}
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "DemoWebApi.dll"]
