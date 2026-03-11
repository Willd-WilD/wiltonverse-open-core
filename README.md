# WiltonVerse Runtime

**An AI governance framework built outside academia — verifiable, reproducible, and honest about what it is.**

---

## 🇧🇷 Português

### O Que É

O WiltonVerse é um framework de governança para sistemas de IA desenvolvido por Wilton Verti — um cabeleireiro brasileiro sem formação acadêmica formal, movido por curiosidade, autodidatismo, e a convicção de que sistemas de IA precisam ser auditáveis por qualquer pessoa, não apenas por instituições.

O projeto nasceu dentro de conversas com modelos de linguagem e evoluiu, ao longo de mais de 2.900 sessões documentadas, para um sistema com arquitetura real, evidência criptográfica, e ciclo de reprodução verificável em ambiente independente.

### O Que Este Repositório Contém

Este repositório contém o **WiltonVerse Runtime Pack** — o pacote portátil que permite executar e verificar o estado canônico do sistema em qualquer máquina com Windows.

```
00_manifest/    → Manifesto canônico com hashes SHA-256
01_state/       → Estado atual do sistema e changelog
02_governance/  → Regras de governança, Truth Policy, Evidence Policy
03_registry/    → Registro de módulos e agentes
04_runtime/     → Configuração de execução
05_benchmarks/  → Suite de benchmarks com 8 verificações
06_operator/    → Perfil do operador
07_export/      → Resumo de estado, instruções de reprodução, limitações conhecidas
10_scripts/     → Scripts PowerShell para execução do ciclo completo
11_docs/        → Runbook, checklist, protocolos de auditoria e replicação
12_schemas/     → Schemas de validação JSON
```

### Como Executar

**Requisitos:** Windows 10/11, PowerShell 5+

```powershell
# 1. Clone o repositório
git clone https://github.com/Willd-WilD/wiltonverse-open-core
cd wiltonverse-open-core

# 2. Entre na pasta de scripts
cd 10_scripts

# 3. Libere a execução
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 4. Execute o ciclo completo
.\run_full_cycle.ps1
```

O ciclo executa verificação de ambiente, compilação, snapshot de estado, heartbeat, benchmark, verificação de integridade e geração de pacote de evidência — tudo em sequência, com artefatos físicos gerados em `08_evidence/`.

### Estado Atual Verificado

| Gate | Status | Evidência |
|------|--------|-----------|
| G4 — Execução PowerShell real | ✅ VERIFIED | SHA-256 executado em 2025-12-29 |
| G5 — Telemetria e fail-closed | ✅ VERIFIED | Testes Tyche em 2025-12-29 |
| G6 — Reprodução independente | ✅ VERIFIED | Windows Sandbox — ambiente virgem, 13/13 hashes idênticos, benchmark 8/8 — 100% |

**Truth State: VERIFIED**

Todos os hashes são publicamente verificáveis. Qualquer pessoa pode clonar, executar `verify_pack.ps1`, e confirmar os resultados.

### Limitações Honestas

Este projeto não esconde o que ainda não é:

- Não é um sistema em execução contínua 24/7
- Não foi reproduzido por um operador fisicamente independente em outra máquina (ainda)
- Os agentes descritos nos YAMLs operam dentro de sessões de LLM, não como processos autônomos contínuos
- A governança é real como design e evidência — não como enforcement automatizado em produção

A Truth Policy governa o que pode e o que não pode ser afirmado. Afirmações sem evidência são proibidas pelo próprio sistema.

### Sobre o Fundador

Wilton Verti é cabeleireiro em São Paulo, Brasil. Não tem diploma universitário. Construiu este sistema ao longo de anos de estudo autodidático, dezenas de sessões semanais com modelos de IA, e uma exigência pessoal de que cada afirmação fosse sustentada por evidência real — não por linguagem.

O WiltonVerse existe porque uma pessoa sem recursos institucionais decidiu que rigor e honestidade não são privilégio acadêmico.

---

## 🇺🇸 English

### What This Is

WiltonVerse is an AI governance framework built by Wilton Verti — a Brazilian hairdresser with no formal academic background, driven by curiosity, self-directed learning, and the conviction that AI systems must be auditable by anyone, not only by institutions.

The project grew from conversations with language models and evolved, across more than 2,900 documented sessions, into a system with real architecture, cryptographic evidence, and a reproducible verification cycle validated in an independent environment.

### What This Repository Contains

This repository contains the **WiltonVerse Runtime Pack** — a portable package that allows anyone to execute and verify the canonical system state on any Windows machine.

### How to Run

**Requirements:** Windows 10/11, PowerShell 5+

```powershell
git clone https://github.com/Willd-WilD/wiltonverse-open-core
cd wiltonverse-open-core\10_scripts
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\run_full_cycle.ps1
```

The cycle runs environment checks, compilation, state snapshot, heartbeat, benchmark, integrity verification, and evidence bundle generation — all in sequence, producing physical artifacts in `08_evidence/`.

### Verified State

| Gate | Status | Evidence |
|------|--------|----------|
| G4 — Real PowerShell execution | ✅ VERIFIED | SHA-256 executed 2025-12-29 |
| G5 — Telemetry and fail-closed | ✅ VERIFIED | Tyche tests 2025-12-29 |
| G6 — Independent reproduction | ✅ VERIFIED | Windows Sandbox — virgin environment, 13/13 hashes identical, benchmark 8/8 — 100% |

**Truth State: VERIFIED**

All hashes are publicly verifiable. Anyone can clone, run `verify_pack.ps1`, and confirm the results independently.

### Honest Boundaries

This project does not hide what it is not yet:

- Not a continuously running 24/7 system
- Not yet reproduced by a physically independent operator on a separate machine
- Agents described in YAMLs operate within LLM sessions, not as continuous autonomous processes
- Governance is real as design and evidence — not as automated enforcement in production

The Truth Policy governs what can and cannot be claimed. Claims without evidence are prohibited by the system itself.

### About the Founder

Wilton Verti is a hairdresser in São Paulo, Brazil. He holds no university degree. He built this system through years of self-directed study, dozens of weekly sessions with AI models, and a personal demand that every claim be supported by real evidence — not language.

WiltonVerse exists because a person without institutional resources decided that rigor and honesty are not academic privileges.

---

## Architecture Overview

```
Constitutional Layer        → Governance rules that cannot be overridden
Truth Policy                → What can be claimed and at what evidence threshold
Anti-Hallucination Layer    → Explicit prohibition of claims without evidence
Evidence Policy             → DECLARED / PARTIAL_VERIFIED / VERIFIED promotion criteria
Canonical Manifest          → SHA-256 sealed state of all core files
Runtime Scripts             → Executable verification cycle (PowerShell)
Benchmark Suite             → 8 automated checks scored 0-100%
```

## Key Files

| File | Purpose |
|------|---------|
| `02_governance/truth_policy.yaml` | Defines what constitutes a valid claim |
| `02_governance/evidence_policy.yaml` | Defines promotion criteria between truth states |
| `00_manifest/canonical_manifest.yaml` | SHA-256 hashes of all canonical files |
| `10_scripts/run_full_cycle.ps1` | Executes the complete verification cycle |
| `10_scripts/verify_pack.ps1` | Standalone integrity verification |

---

## Contact

Wilton Verti — São Paulo, Brazil  
GitHub: [@Willd-WilD](https://github.com/Willd-WilD)

*Interested in AI governance, reproducibility, or epistemic honesty in AI systems? Open an issue or reach out.*

---

> *"Built without institutional resources. Driven by the belief that anyone who demands evidence and refuses to accept illusion is doing serious work — regardless of their credentials."*
