# =========================
# 1️⃣ Build stage
# =========================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Копираме solution и csproj (за cache optimization)
COPY DemoWebApi.sln .
COPY DemoWebApi/DemoWebApi.csproj ./DemoWebApi/

# Restore
RUN dotnet restore

# Копираме останалия код
COPY . .

# Publish
RUN dotnet publish DemoWebApi/DemoWebApi.csproj -c Release -o /app/publish --no-restore

# =========================
# 2️⃣ Runtime stage
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

EXPOSE 8080

ENTRYPOINT ["dotnet", "DemoWebApi.dll"]
