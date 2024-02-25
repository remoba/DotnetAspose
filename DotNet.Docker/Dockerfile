FROM dotnet/sdk-aspose:6.0 AS build-env
WORKDIR /App

COPY . ./

RUN dotnet restore

RUN dotnet publish -c Release -o out

FROM dotnet/runtime-aspose:6.0
WORKDIR /App

COPY --from=build-env /App/out .

ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]