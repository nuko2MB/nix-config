{ ... }: # prismlauncher-git
final: prev: {
  # prismlauncher = prismlauncher-git.packages.${prev.system}.prismlauncher.override {
  prismlauncher = prev.prismlauncher.override {
    jdks = with prev; [
      jdk8
      jdk17
      jdk19
      jdk21
    ];
  };
}
