# Wiltonverse Open Core

![MIT License](https://img.shields.io/badge/license-MIT-green)
![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)
![Made in Brazil](https://img.shields.io/badge/made%20in-Brazil-00bfff)

> **The first living AI ecosystem made in Brazil, for the world.**

---

## 🚦 Como Usar o Wiltonverse (Guia para Todos os Níveis)

### Leigos (Zero Dev)
- Explore exemplos em `/examples` e `/docs`.
- Copie YAML/prompts e cole no ChatGPT, Claude, Perplexity ou outro chat de IA.
- Veja instruções em [docs/quickstart_pt.md](docs/quickstart_pt.md) ou [docs/quickstart_en.md](docs/quickstart_en.md).

### Dev Intermediário
- Importe YAML/Markdown em Notion, Zapier, Make, etc.
- Rode scripts Python/Node com API da OpenAI ou outra LLM.
- Customizar automações, relatórios e dashboards.

### Expert em IA
- Fork/clonar o repo e modificar blueprints conforme seu projeto.
- Criar sua interface (CLI, webapp, bot).
- Contribuir para a comunidade Wiltonverse.

---

## 🚀 Exemplo: Rodando Wiltonverse com API OpenAI (Python)

Crie a pasta `/scripts` e salve como `run_wiltonverse_agent.py`:

```python
import openai

def load_blueprint(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()

def run_agent(prompt, model="gpt-4"):
    openai.api_key = "SUA_OPENAI_KEY"
    response = openai.ChatCompletion.create(
        model=model,
        messages=[
            {"role": "system", "content": "Você é um agente do Wiltonverse."},
            {"role": "user", "content": prompt}
        ]
    )
    print("\nResposta Wiltonverse:\n")
    print(response.choices[0].message['content'])

if __name__ == "__main__":
    blueprint = load_blueprint('docs/blueprint_en.yaml')
    run_agent(blueprint)
```

Para rodar:
```bash
python scripts/run_wiltonverse_agent.py
```

---

## 📦 FAQ

- **Preciso programar para usar?**  
  Não! Pode só copiar prompts no ChatGPT. Programadores automatizam ainda mais.
- **O que é um blueprint?**  
  É um roteiro/prompt YAML pronto para IA executar.
- **Posso rodar localmente?**  
  Sim, com Python e API de IA.
- **Tem planos para webapp/bot?**  
  Sim, comunidade aberta! Sugira/contribua.
- **Quero vídeo/tutorial!**  
  Em breve! Abra uma issue ou peça por email.

---

**Wiltonverse: evolua, compartilhe, use — IA acessível de verdade para todos.**
