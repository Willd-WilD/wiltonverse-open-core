#!/usr/bin/env python3
"""
WiltonVerse - parse_chatgpt_export.py
--------------------------------------
Processa um ou múltiplos arquivos conversations.json do export do ChatGPT.
Funciona com exports divididos em várias partes.

Uso — pasta com múltiplos arquivos:
    python parse_chatgpt_export.py --folder "C:\\caminho\\para\\pasta_extraida"

Uso — arquivo único:
    python parse_chatgpt_export.py --input conversations.json

Saída em:
    07_export/chatgpt_wv_conversations.md
    07_export/chatgpt_wv_structured.json
    07_export/registry_patch_from_export.yaml
    07_export/export_parse_evidence.json
"""

import json
import os
import sys
import hashlib
import argparse
import re
from datetime import datetime, timezone
from pathlib import Path

try:
    import yaml
except ImportError:
    print("[ERRO] PyYAML não instalado. Rode: python -m pip install pyyaml")
    sys.exit(1)

WV_KEYWORDS = [
    "wiltonverse", "wilton verse", "wv_", "rcmas", "mag-pd", "nucleus enterprise",
    "truth_policy", "truth policy", "verified", "declared", "unknown",
    "fail_closed", "fail-closed", "add_only", "add-only",
    "anti-illusion", "anti_illusion", "constitutional layer",
    "governance", "governança", "epistemic", "epistemológico",
    "provenance", "provenância", "sha-256", "rfc3161",
    "meta-agente", "meta-agent", "kernel governado",
    "module_registry", "canonical_manifest", "benchmark_harness",
    "pró-labore", "pro-labore", "mei ", "nf-e", "das boleto",
    "heartbeat", "runtime fabric", "compilation layer",
    "bayesian", "lyapunov", "coherence index",
    "wilton", "wv-", "agente", "agent",
]

MODULE_PATTERNS = [
    r'\bWV[-_][A-Z0-9\-_]+\b',
    r'\bRCMAS[-_][A-Z0-9\-_]*\b',
    r'\bMAG[-_]PD\b',
    r'\bNUCLEUS\b',
]


def sha256_of_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def is_wv_relevant(text) -> bool:
    if not text:
        return False
    text_lower = str(text).lower()
    return any(kw.lower() in text_lower for kw in WV_KEYWORDS)


def extract_module_ids(text: str) -> list:
    found = set()
    for pattern in MODULE_PATTERNS:
        matches = re.findall(pattern, text, re.IGNORECASE)
        found.update(m.upper() for m in matches)
    return sorted(found)


def extract_messages(conversation: dict) -> list:
    messages = []
    mapping = conversation.get("mapping", {})
    for node_id, node in mapping.items():
        msg = node.get("message")
        if not msg:
            continue
        content = msg.get("content", {})
        if isinstance(content, dict):
            parts = content.get("parts", [])
            text = " ".join(str(p) for p in parts if isinstance(p, str))
        elif isinstance(content, str):
            text = content
        else:
            text = ""
        if not text.strip():
            continue
        role = msg.get("author", {}).get("role", "unknown")
        ts = msg.get("create_time")
        messages.append({"role": role, "text": text.strip(), "ts": ts})
    messages.sort(key=lambda m: m.get("ts") or 0)
    return messages


def load_conversations_from_folder(folder: Path) -> list:
    """Find and load all conversations.json files in a folder tree."""
    all_convs = []
    files_found = list(folder.rglob("conversations.json"))
    
    if not files_found:
        print(f"[ERRO] Nenhum arquivo conversations.json encontrado em: {folder}")
        sys.exit(1)
    
    print(f"       Encontrados {len(files_found)} arquivos conversations.json")
    
    seen_ids = set()
    for fpath in sorted(files_found):
        try:
            with open(fpath, "r", encoding="utf-8", errors="replace") as f:
                data = json.load(f)
            if isinstance(data, list):
                before = len(all_convs)
                for conv in data:
                    cid = conv.get("id", "")
                    if cid and cid not in seen_ids:
                        seen_ids.add(cid)
                        all_convs.append(conv)
                added = len(all_convs) - before
                print(f"       {fpath.name}: {added} conversas carregadas")
            else:
                print(f"       [AVISO] {fpath.name}: formato inesperado, ignorado")
        except Exception as e:
            print(f"       [AVISO] {fpath.name}: erro ao ler ({e}), pulando")
    
    return all_convs


def process(all_conversations: list, output_dir: Path, source_label: str):
    output_dir.mkdir(parents=True, exist_ok=True)
    total = len(all_conversations)
    print(f"\n[2/5] Filtrando conteúdo WiltonVerse em {total} conversas...")

    relevant = []
    all_module_ids = set()

    for conv in all_conversations:
        title = conv.get("title", "Sem título")
        messages = extract_messages(conv)
        full_text = " ".join(m["text"] for m in messages)
        if is_wv_relevant(full_text) or is_wv_relevant(title):
            module_ids = extract_module_ids(full_text)
            all_module_ids.update(module_ids)
            relevant.append({
                "id": conv.get("id", "unknown"),
                "title": title,
                "create_time": conv.get("create_time"),
                "message_count": len(messages),
                "module_ids_found": module_ids,
                "messages": messages,
                "text_hash": sha256_of_text(full_text),
            })

    print(f"       {len(relevant)} de {total} conversas são relevantes ao WiltonVerse")
    print(f"       IDs de módulos encontrados: {len(all_module_ids)}")

    if not relevant:
        print("\n[AVISO] Nenhuma conversa WiltonVerse encontrada.")
        print("  Verifique se a pasta correta foi informada.")
        sys.exit(0)

    relevant.sort(key=lambda c: c.get("create_time") or 0)

    # Markdown
    print(f"[3/5] Gerando resumo em markdown...")
    md_path = output_dir / "chatgpt_wv_conversations.md"
    with open(md_path, "w", encoding="utf-8") as f:
        f.write("# WiltonVerse — Resumo do Export ChatGPT\n\n")
        f.write(f"- Gerado em: {datetime.now(timezone.utc).isoformat()}\n")
        f.write(f"- Conversas escaneadas: {total}\n")
        f.write(f"- Relevantes ao WiltonVerse: {len(relevant)}\n")
        f.write(f"- Módulos detectados: {', '.join(sorted(all_module_ids)) or 'nenhum'}\n\n---\n\n")
        for i, conv in enumerate(relevant, 1):
            ts = conv.get("create_time")
            date_str = datetime.fromtimestamp(ts).strftime("%Y-%m-%d") if ts else "data desconhecida"
            f.write(f"## {i}. {conv['title']}\n\n")
            f.write(f"- Data: {date_str}\n")
            f.write(f"- Mensagens: {conv['message_count']}\n")
            f.write(f"- Módulos: {', '.join(conv['module_ids_found']) or 'nenhum detectado'}\n\n")
            user_msgs = [m for m in conv["messages"] if m["role"] == "user"][:2]
            for m in user_msgs:
                preview = m["text"][:300].replace("\n", " ")
                f.write(f"> {preview}{'...' if len(m['text']) > 300 else ''}\n\n")
            f.write("---\n\n")

    # JSON estruturado
    print(f"[4/5] Gerando JSON estruturado...")
    json_path = output_dir / "chatgpt_wv_structured.json"
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump({
            "meta": {
                "generated_at": datetime.now(timezone.utc).isoformat(),
                "total_scanned": total,
                "wv_relevant": len(relevant),
                "module_ids_found": sorted(all_module_ids),
            },
            "conversations": [{
                "id": c["id"],
                "title": c["title"],
                "message_count": c["message_count"],
                "module_ids_found": c["module_ids_found"],
                "text_hash": c["text_hash"],
            } for c in relevant]
        }, f, indent=2, ensure_ascii=False)

    # Registry patch
    print(f"[5/5] Gerando patch do registro de módulos...")
    patch_modules = []
    for mod_id in sorted(all_module_ids):
        patch_modules.append({
            "id": mod_id,
            "name": mod_id.replace("WV-", "").replace("-", " ").title(),
            "class": "PREENCHER",
            "purpose": "PREENCHER — detectado no histórico do ChatGPT",
            "status": "REVISAR",
            "truth_state": "DECLARED",
            "owner": "Wiltonverse",
            "dependencies": [],
            "promotable": True,
            "runtime_capable": False,
            "notes": "Detectado automaticamente. Requer revisão manual.",
        })

    patch_path = output_dir / "registry_patch_from_export.yaml"
    with open(patch_path, "w", encoding="utf-8") as f:
        yaml.dump({
            "registry_patch_version": "1.0.0",
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "truth_state": "DECLARED",
            "instrucao": "Revise cada módulo abaixo. Preencha 'class' e 'purpose'. Incorpore ao module_registry.yaml.",
            "modulos_detectados": patch_modules,
        }, f, allow_unicode=True, sort_keys=False, default_flow_style=False)

    # Evidência com hashes
    evidence = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "source": source_label,
        "outputs": {}
    }
    for out_path in [md_path, json_path, patch_path]:
        with open(out_path, "rb") as f:
            evidence["outputs"][out_path.name] = hashlib.sha256(f.read()).hexdigest()

    evidence_path = output_dir / "export_parse_evidence.json"
    with open(evidence_path, "w", encoding="utf-8") as f:
        json.dump(evidence, f, indent=2)

    print(f"\n{'='*55}")
    print(f"  CONCLUÍDO")
    print(f"{'='*55}")
    print(f"  Conversas relevantes : {len(relevant)}")
    print(f"  Módulos detectados   : {len(all_module_ids)}")
    print(f"\n  Arquivos gerados em: {output_dir}")
    print(f"    chatgpt_wv_conversations.md  — resumo legível")
    print(f"    chatgpt_wv_structured.json   — dados estruturados")
    print(f"    registry_patch_from_export.yaml — patch para revisar")
    print(f"    export_parse_evidence.json   — hashes de evidência")
    print(f"\n  Próximo passo:")
    print(f"    Abra registry_patch_from_export.yaml")
    print(f"    Preencha 'PREENCHER' em cada módulo")
    print(f"    Incorpore ao 03_registry/module_registry.yaml")
    print(f"{'='*55}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Processa export do ChatGPT e extrai conteúdo WiltonVerse"
    )
    parser.add_argument("--folder", default=None,
        help="Pasta contendo os arquivos conversations.json (para exports divididos)")
    parser.add_argument("--input", default=None,
        help="Caminho para um único conversations.json")
    parser.add_argument("--output", default="../07_export/",
        help="Pasta de saída (padrão: ../07_export/)")
    args = parser.parse_args()

    print(f"\n{'='*55}")
    print(f"  WiltonVerse — Parser de Export ChatGPT")
    print(f"  {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'='*55}\n")

    output_dir = Path(args.output)

    if args.folder:
        folder = Path(args.folder)
        if not folder.exists():
            print(f"[ERRO] Pasta não encontrada: {folder}")
            sys.exit(1)
        print(f"[1/5] Carregando arquivos da pasta: {folder}")
        conversations = load_conversations_from_folder(folder)
        source_label = str(folder)
    elif args.input:
        input_path = Path(args.input)
        if not input_path.exists():
            print(f"[ERRO] Arquivo não encontrado: {input_path}")
            sys.exit(1)
        print(f"[1/5] Carregando arquivo: {input_path}")
        with open(input_path, "r", encoding="utf-8", errors="replace") as f:
            conversations = json.load(f)
        source_label = str(input_path)
    else:
        print("[ERRO] Informe --folder ou --input")
        print("Exemplo: python parse_chatgpt_export.py --folder \"F:\\WiltonVerse Bruto marco\\pasta_extraida\"")
        sys.exit(1)

    print(f"       Total de conversas carregadas: {len(conversations)}")
    process(conversations, output_dir, source_label)
