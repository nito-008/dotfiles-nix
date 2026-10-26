{ pkgs, ... }:
let
  # Cosense (formerly Scrapbox) CLI by Helpfeel - read, search, and edit pages
  cosense-cli = pkgs.buildNpmPackage (finalAttrs: {
    pname = "cosense-cli";
    version = "1.17.1";

    src = pkgs.fetchFromGitHub {
      owner = "helpfeel";
      repo = "cosense-cli";
      tag = "v${finalAttrs.version}";
      hash = "sha256-VOAyQ4GPstC8BCsf/dU9nXL5JQ8VT4AOQBmJtJ8sTWc=";
    };

    npmDepsHash = "sha256-qBjNrJ+cBZS2KHftg+LvAvip+E3WqR2jFRecxly8boo=";

    # Requires Node.js >= 24
    nodejs = pkgs.nodejs_24;

    # TypeScript sources run directly through tsx; no build step
    dontNpmBuild = true;

    meta = {
      description = "CLI for reading, searching, and editing Cosense pages";
      homepage = "https://github.com/helpfeel/cosense-cli";
      license = pkgs.lib.licenses.mit;
      mainProgram = "cosense";
    };
  });
in
{
  environment.systemPackages = [ cosense-cli ];
}
