FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["kubeaspnetapp/kubeaspnetapp.csproj", "kubeaspnetapp/"]

RUN dotnet restore "kubeaspnetapp/kubeaspnetapp.csproj"
COPY . .
WORKDIR "/src/kubeaspnetapp"
RUN dotnet build "kubeaspnetapp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "kubeaspnetapp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "kubeaspnetapp.dll"]