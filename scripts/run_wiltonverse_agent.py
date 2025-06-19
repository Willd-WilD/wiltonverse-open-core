import openai

# Insira sua API Key da OpenAI abaixo:
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
