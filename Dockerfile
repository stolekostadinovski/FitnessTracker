# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

# Copy the csproj file and restore dependencies
COPY FitnessTracker/*.csproj ./FitnessTracker/
RUN dotnet restore FitnessTracker/*.csproj

# Copy the entire project and build the app
COPY FitnessTracker/. ./FitnessTracker/
WORKDIR /app/FitnessTracker
RUN dotnet publish -c Release -o out

# Use the official ASP.NET Core runtime as the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/FitnessTracker/out .

# Expose port 80
EXPOSE 80

# Set the entry point to run the app
ENTRYPOINT ["dotnet", "FitnessTracker.dll"]
