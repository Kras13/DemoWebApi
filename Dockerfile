# =========================
# 1️⃣ Build stage
# =========================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Копиране на solution файла
COPY DemoWebApi/DemoWebApi.sln ./DemoWebApi/

# Копиране на csproj файла (за по-добър cache)
COPY DemoWebApi/DemoWebApi/DemoWebApi.csproj ./DemoWebApi/DemoWebApi/

# Restore
RUN dotnet restore DemoWebApi/DemoWebApi.sln

# Копиране на останалия код
COPY DemoWebApi/. ./DemoWebApi/

# Publish
WORKDIR /src/DemoWebApi/DemoWebApi
RUN dotnet publish -c Release -o /app/publish --no-restore

# =========================
# 2️⃣ Runtime stage
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Копиране на публикуваното приложение
COPY --from=build /app/publish .

# Environment (по желание)
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

EXPOSE 8080

ENTRYPOINT ["dotnet", "DemoWebApi.dll"]
