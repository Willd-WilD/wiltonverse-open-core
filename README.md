# Wiltonverse Open Core

![Wiltonverse](docs/banner.png)
![MIT License](https://img.shields.io/badge/license-MIT-green)
![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)
![Made in Brazil](https://img.shields.io/badge/made%20in-Brazil-00bfff)
![Living AI](https://img.shields.io/badge/living%20AI-eternal-informational)

> **The first living AI ecosystem made in Brazil, for the world.**

---

## 🚦 How to Use Wiltonverse (For All Levels)

### Beginner / Non-Dev
- Explore `/examples` and `/docs` files.
- Copy YAML/prompts, paste into ChatGPT, Claude, Perplexity, or any LLM.
- Step-by-step in [docs/quickstart_en.md](docs/quickstart_en.md).

### Intermediate Dev
- Import YAML/Markdown into Notion, Zapier, Make, etc.
- Run Python/Node scripts using OpenAI or another LLM API.
- Customize automations, reports, and dashboards.

### AI Expert
- Fork/clone and tweak blueprints for your own project.
- Create custom interfaces (CLI, webapp, bot).
- Contribute back new modules and cases.

---

## 🚀 Example: Running Wiltonverse with OpenAI API (Python)

Create `/scripts/run_wiltonverse_agent.py` and run:

```python
import openai

# Insert your OpenAI API key here!
openai.api_key = "SUA_OPENAI_KEY"

def load_blueprint(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()

def run_agent(prompt, model="gpt-4"):
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

**To run:**
```bash
python scripts/run_wiltonverse_agent.py
```

**Example output:**  
```
Resposta Wiltonverse:

Bem-vindo ao Wiltonverse! Agente inicializado e pronto para orquestrar fluxos inteligentes.
```

---

## 📦 [FAQ completo →](./FAQ.md)

---

## 🤝 Contribua

- Quer colaborar?  
  Abra uma *Issue*, faça um *Pull Request*, compartilhe feedback ou novas ideias!
- Ajude a expandir exemplos, integrar com novas plataformas e criar onboarding para leigos.
- Proponha tutoriais, vídeos, prints ou bots.  
- **Wiltonverse = feito por todos, para todos.**

---

## 📣 Divulgação (Copy pronta para LinkedIn, Medium, Grupos)

> 🚀 Proud to launch [Wiltonverse Open Core](https://github.com/Willd-WilD/wiltonverse-open-core): the first “living AI ecosystem” made in Brazil for the world.
>
> Modular, autocritical, accessible — plug-and-play for beginners, devs and AI experts.  
> Fully open source, multi-agent, YAML-powered, with docs and examples for everyone.
>
> Fork, use, remix and help us evolve!  
> #AI #opensource #wiltonverse #BrazilToTheWorld

---

## 🇧🇷 **Como Usar o Wiltonverse (Guia para Todos os Níveis)**

### Leigos (Zero Dev)
- Explore exemplos em `/examples` e `/docs`.
- Copie YAML/prompts e cole no ChatGPT, Claude, Perplexity ou outro chat de IA.
- Veja instruções em [docs/quickstart_pt.md](docs/quickstart_pt.md).

### Dev Intermediário
- Importe YAML/Markdown em Notion, Zapier, Make, etc.
- Rode scripts Python/Node com API da OpenAI ou outra LLM.
- Customize automações, relatórios e dashboards.

### Expert em IA
- Fork/clonar o repo e modificar blueprints conforme seu projeto.
- Criar sua interface (CLI, webapp, bot).
- Contribuir para a comunidade Wiltonverse.

---

**Wiltonverse: evolua, compartilhe, use — IA acessível de verdade para todos.**
