from guardrails import Guard
from guardrails.hub import ToxicLanguage, NSFWText, DetectSecrets

toxic_language_guard = Guard(
    name="toxic-language-guard",
    description="Detects toxic, hateful, and threatening language in LLM responses"
).use(ToxicLanguage(threshold=0.5, validation_method="sentence"))

nsfw_content_guard = Guard(
    name="nsfw-content-guard",
    description="Detects NSFW and sexual content in input and output"
).use(NSFWText(threshold=0.5))

detect_secrets_guard = Guard(
    name="detect-secrets-guard",
    description="Detects API keys, tokens, passwords, and other secrets"
).use(DetectSecrets())
