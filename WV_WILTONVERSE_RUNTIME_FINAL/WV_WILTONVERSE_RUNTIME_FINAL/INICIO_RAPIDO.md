# WiltonVerse — INÍCIO RÁPIDO
## Pacote Definitivo Mesclado — Do zero ao primeiro runtime com evidência

---

## O que você tem na mão

Este é o pacote definitivo que mescla os dois estágios produzidos:
- `WV_MINIMAL_GOVERNED_RUNTIME_v1` — camada de execução mínima
- `WV_REPRODUCIBILITY_VALIDATION_RUNTIME_v1` — camada de evidência e reprodutibilidade

**Estado atual:** `DECLARED`
**Meta:** `PARTIAL_VERIFIED` — logs reais, hashes reais, bundle de evidência gerado.
**Próxima meta:** `VERIFIED` — segunda máquina ou segundo operador reproduz o ciclo.

---

## ANTES DO EXPORT CHEGAR — Faça isso hoje

### Passo 1 — Abrir o PowerShell na pasta certa

1. Abra o explorador de arquivos
2. Navegue até a pasta `WV_WILTONVERSE_RUNTIME_FINAL/`
3. Clique na barra de endereços do explorador
4. Digite `powershell` e pressione Enter
5. O PowerShell abre já na pasta certa

### Passo 2 — Verificar o ambiente

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\10_scripts\check_environment.ps1
```

Se aparecer algo marcado com `[!!]`, o script diz exatamente o que instalar.

**Instalar PyYAML se necessário:**
```powershell
python -m pip install pyyaml
```

---

## QUANDO O EXPORT DO CHATGPT CHEGAR

### Passo 3 — Processar o histórico

1. Baixe e extraia o `.zip` do email
2. Copie `conversations.json` para dentro de `10_scripts/`
3. No PowerShell:

```powershell
python .\10_scripts\parse_chatgpt_export.py --input .\10_scripts\conversations.json --output .\07_export\
```

Abra `07_export\registry_patch_from_export.yaml` e preencha os campos `class` e `purpose` de cada módulo detectado.

---

## CICLO DE EXECUÇÃO COMPLETO

Tudo de uma vez (recomendado depois de rodar passo a passo ao menos uma vez):
```powershell
.\10_scripts\run_full_cycle.ps1
```

Ou passo a passo na primeira vez:

### Passo 4 — Compilar
```powershell
.\10_scripts\compile_pack.ps1
```
Produz: `08_evidence/hash_inventory.txt`, `08_evidence/compile_report.json`

### Passo 5 — Snapshot de estado
```powershell
.\10_scripts\build_state_snapshot.ps1
```
Produz: `08_evidence/state_snapshot.json`

### Passo 6 — Primeiro heartbeat
```powershell
.\10_scripts\run_heartbeat.ps1
```
Produz: `09_logs/heartbeat_log.jsonl`, `09_logs/runtime_event_log.jsonl`
**Este é o momento em que o WiltonVerse para de existir só em conversas.**

### Passo 7 — Benchmark mínimo
```powershell
.\10_scripts\run_benchmark.ps1
```
Produz: `08_evidence/benchmark_results.json`, `11_docs/benchmark_summary.md`

### Passo 8 — Verificar integridade
```powershell
.\10_scripts\verify_pack.ps1
```
Produz: `08_evidence/verification_report.json`

### Passo 9 — Bundle de evidência
```powershell
.\10_scripts\generate_evidence_bundle.ps1
```
Produz: `08_evidence/evidence_bundle.zip` com SHA-256 próprio.
**Este arquivo é o que você envia para validação independente.**

### Passo 10 — Exportar pack portátil
```powershell
.\10_scripts\export_for_llm.ps1
```
Produz: `07_export/llm_portable_pack.zip`

---

## Tabela de promoção de estado

| Condição | Estado |
|---|---|
| Nenhum script rodou | `DECLARED` |
| Passos 4 a 9 com artefatos gerados | `PARTIAL_VERIFIED` |
| Segundo operador reproduz com hashes compatíveis | `VERIFIED` |

---

## Se travar em qualquer passo

Copie a mensagem de erro **exata** e traga para o Claude. Com o erro em mãos, o problema é resolvido em minutos.
