# Shuffle security fork

Shuffle keeps the existing Terragrunt Atlantis Config generator because its
project names, environment filtering, and dependency detection are part of the
Atlantis deployment contract. This is a dependency-maintenance fork, not a
replacement implementation of the generator.

As of 2026-11-02, upstream's latest published binary is v1.21.1 from October
2025. Trivy 0.70.0 reports 55 fixable HIGH and two CRITICAL findings in that
official ARM64 binary. The critical findings include CVE-2026-33186 in gRPC
and CVE-2025-68121 in Go's TLS implementation. Official v1.20.0, v1.19.0, and
v1.18.0 binaries also fail the same scan, so downgrading does not resolve it.

The fork pins Go 1.27.3 and updates vulnerable dependencies in go.mod and
go.sum. Generator implementation and existing golden files remain unchanged.
The module path stays upstream-compatible because the code imports its own
packages using that path; source provenance comes from the pinned fork commit.
The reported version is 1.21.1-shuffle.1 so the result is identifiable as a
Shuffle build rather than an official upstream binary.

The Atlantis image builds this source in a separate native builder stage and
copies only the resulting binary and its MIT license into the runtime. The
source commit and archive SHA-256 are pinned. Builds use -mod=readonly and
must not run go get or otherwise change the committed dependency graph.

Before updating the image pin, run the complete upstream test suite and its
golden-output checks, build the Linux ARM64 binary, and scan that binary with
the image's Trivy policy. The complete image must also pass its existing
vulnerability, signing, and attestation checks before promotion.

Return to an official upstream release when it contains the dependency and Go
toolchain fixes, passes the same scan, and preserves the tested generator
output. Until then, maintain changes as reviewable commits in this fork.
