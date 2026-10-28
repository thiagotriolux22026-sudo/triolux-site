# Site Triolux Iluminação

Site institucional da Triolux (página única, HTML puro, sem etapa de build), servido por nginx em Docker.

## Arquivos

| Arquivo | Para que serve |
|---|---|
| `index.html` | O site inteiro (textos, estilos e scripts) |
| `img/` | Fotos, logos e ícones |
| `404.html` | Página de "não encontrado" |
| `site.webmanifest`, `robots.txt` | Ícones do site e orientação para o Google |
| `nginx.conf`, `seguranca.conf` | Configuração do servidor (compressão, cache e cabeçalhos de segurança) |
| `40-site-url.sh` | Ajusta o site na hora de ligar, usando as variáveis abaixo |
| `Dockerfile` | Receita para montar o container |

## Variáveis (Easypanel, aba Ambiente)

| Variável | Para que serve |
|---|---|
| `CRM_URL` | Endereço do CRM, sem barra no fim (hoje `https://cmr-triolux-crm.nrzz4w.easypanel.host`). Dele saem o catálogo (`/vitrine`) e o chat Lighting Suporte (`/chat`). |
| `SITE_URL` | Endereço final do site, por exemplo `https://triolux.com.br`, sem barra no fim. Preenche o endereço canônico, a imagem de compartilhamento e o `sitemap.xml`. Se ficar vazia, o site funciona normalmente, só sem esses itens. |

## Como atualizar

1. Troque os arquivos no GitHub (**Add file > Upload files**).
2. No Easypanel, clique em **Implantar**.

## Chat Lighting Suporte e pedidos

- O chat do site é a página `/chat` do CRM, dentro de uma janela flutuante. Para ele responder, ligue **Chat do site** no CRM (Configurações, na parte de IA/atendimento) e deixe a chave da IA configurada.
- Os contatos deixados no chat viram negócio no CRM, com origem "Site".
- A seção "Conheça o nosso CRM" mostra o CRM inteiro (a tela do sistema, `CRM_URL`) numa janela; o botão "Fazer pedido de produtos" abre a vitrine (`/vitrine`) para os clientes. Os pedidos chegam como "Orçamento". O CRM só aparece dentro do site se ele estiver no mesmo domínio do site (ou listado em `EMBED_ORIGINS` no CRM); senão a janela mostra o link "Abrir em outra aba".
- Se o chat do CRM não abrir em 10 segundos, o site troca sozinho para o "modo básico" do Lighting Suporte (responde dúvidas simples, estima luminárias e leva a conversa para o WhatsApp).
- **Antes de publicar este site, instale o CRM v104 ou mais novo** (`triolux-crm-v104` ou posterior): nele, quem cria conta nova fica pendente até o dono aprovar.
- Para o chat ficar com o visual do site (claro, com sugestões de assunto, botão do WhatsApp), o CRM precisa do `chat.html` novo (pacote `triolux-crm-v101-chat`).

## Animações da página (v16)

Tudo está no `index.html`, sem biblioteca nenhuma. Para animar um bloco novo, basta colocar a classe:

| Classe | O que faz |
|---|---|
| `rv` | O bloco sobe e aparece quando entra na tela. Variações: `rv l` (vem da esquerda), `rv r` (da direita), `rv z` (cresce). |
| `ttl` | Título: as palavras sobem de uma máscara, uma depois da outra. O `<em>` continua com o degradê. |
| `ir` | Imagem: abre com uma cortina e a foto dá um zoom leve. |
| `data-par="0.06"` | Paralaxe leve (a imagem anda um pouco mais devagar ou mais rápido que a rolagem). Desligado no celular. |
| `style="--d:.2s"` | Atraso manual. Sem isso, o que entra junto na tela entra em sequência, sozinho. |

Saída: perto da borda de cima da tela, as imagens e os blocos vão esmaecendo (as imagens também encolhem um pouco, só no modo
completo). Ao rolar de volta, o efeito se desfaz sozinho.

Três modos de animação (botões "Animações do site" no rodapé; a escolha de cada visitante fica guardada no navegador dele):

| Modo | O que o visitante vê |
|---|---|
| Completas | Tudo: deslizar, zoom, paralaxe, cortina de entrada, letreiro e bolinhas. É o padrão. |
| Suaves | As coisas só aparecem e somem (sem deslizar, sem zoom, sem paralaxe); entrada com fade; letreiro e bolinhas bem devagar. É o padrão de quem deixou "reduzir animações" ligado no aparelho. |
| Desligadas | Nada se move (letreiro vira uma linha parada, sem entrada). |

Quem não escolheu nada segue o que o aparelho pede. Ao trocar de modo, a página volta ao topo e toca a entrada de novo (menos em Desligadas).
Se o navegador não guardar a escolha, ela vai no endereço (`?mov=full`, `?mov=lite` ou `?mov=off`).

Segurança: o conteúdo só fica escondido enquanto a página tem a classe `anim` no `<html>` (ligada no começo do `<head>`).
Ela **não** é ligada no modo Desligadas nem sem `IntersectionObserver`, e **sai sozinha** se o script principal não terminar
em 2,5 segundos. Nesses casos o site aparece inteiro, parado. Sem JavaScript também aparece tudo. Ao imprimir, tudo aparece.

Animação de entrada: ao abrir o site pela primeira vez na visita, o logo acende com um brilho e uma cortina sobe revelando a página
(cerca de 2 segundos; no modo Suaves, um fade). Não toca ao recarregar a página, ao voltar, nem em link com `#` no endereço.
Para ver de novo: abra o site numa aba nova, ou troque o modo no rodapé.
Para desligar, no começo do `<head>` troque `INTRO=true` por `INTRO=false`.

Seção nova: **Especialidades** (`#especialidades`, entre Segmentos e a calculadora). Ela só usa textos que já existiam no site.
O link dela está no rodapé; não entrou no menu do topo porque o menu já está cheio em telas médias.
