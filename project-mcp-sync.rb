# typed: false
# frozen_string_literal: true

class ProjectMcpSync < Formula
  desc "Sync project-scoped MCP server definitions between Claude Code and Codex"
  homepage "https://github.com/seungyeop-lee/project-mcp-sync"
  url "https://github.com/seungyeop-lee/project-mcp-sync/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "5e063af8ede66581c90cd2bc96c3a273f9971c8e0fd289eb97db8685efc36a2c"

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
