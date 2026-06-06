# typed: false
# frozen_string_literal: true

class ProjectMcpSync < Formula
  desc "Sync project-scoped MCP server definitions between Claude Code and Codex"
  homepage "https://github.com/seungyeop-lee/project-mcp-sync"
  url "https://github.com/seungyeop-lee/project-mcp-sync/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3e3d69fa9890d3deb9c9d11209a00c76d77ef38e1106e4aae1330ff7b934f7b8"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"project-mcp-sync", "completion")
  end

  test do
    (testpath/".mcp.json").write('{"mcpServers":{"good":{"command":"npx"}}}')
    system bin/"project-mcp-sync", "sync", "--project", testpath
    assert_match "[mcp_servers.good]", (testpath/".codex/config.toml").read
  end
end
