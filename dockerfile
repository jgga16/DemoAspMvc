#imagen base para la publicación
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

#imagen de trabajo para hacer el build
FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["DemoAspMvc.csproj", ""]
RUN dotnet restore "DemoAspMvc.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "DemoAspMvc.csproj" -c Release -o /app


#del resultado del Build se crea la publicación
FROM build AS publish
RUN dotnet publish "DemoAspMvc.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DemoAspMvc.dll"]