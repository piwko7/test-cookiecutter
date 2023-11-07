from dependency_injector import containers, providers


class Container(containers.DeclarativeContainer):
    wiring_config = containers.WiringConfiguration(
        modules=[
            "routers",
        ]
    )
    config = providers.Configuration()
