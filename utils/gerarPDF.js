const fs = require('fs');
const path = require('path');
const puppeteer = require('puppeteer');
const marked = require('marked');

/**
 * Gera um PDF a partir de um texto Markdown.
 * @param {string} markdown - texto em Markdown (tabelas/formatos).
 * @param {string} nomeBase - nome base do arquivo (ex: 'relatorio_aluno')
 * @returns {Promise<string>} - caminho público relativo do PDF (ex: '/public/pdf/relatorio_xxx.pdf')
 */
async function gerarPDF(markdown, nomeBase = 'relatorio') {
  // Converte Markdown -> HTML
  const htmlBody = marked.parse(markdown || '');

  // CSS simples para deixar as tabelas legíveis
  const css = `
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial; padding: 24px; color: #111; }
      h1,h2,h3 { color: #7d53f3; }
      table { border-collapse: collapse; width: 100%; margin-bottom: 16px; }
      table, th, td { border: 1px solid #999; }
      th, td { padding: 6px 8px; text-align: left; vertical-align: top; font-size: 12px; }
      pre { background: #f6f8fa; padding: 8px; overflow-x: auto; }
      code { background: #f6f8fa; padding: 2px 4px; border-radius: 3px; }
    </style>
  `;

  const html = `
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Relatório</title>
        ${css}
      </head>
      <body>
        <div class="container">
          ${htmlBody}
        </div>
      </body>
    </html>
  `;

  // Garante pasta public/pdf
  const pastaPublic = path.join(__dirname, '../public/pdf');
  fs.mkdirSync(pastaPublic, { recursive: true });

  const fileName = `${nomeBase}_${Date.now()}.pdf`;
  const filePath = path.join(pastaPublic, fileName);

  // Inicia Puppeteer (Chromium baixado pelo pacote)
  // Em mac M1/M2 pode precisar de args extras — seguem args seguros.
  const browser = await puppeteer.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
    defaultViewport: { width: 1200, height: 800 },
  });

  try {
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: 'networkidle0' });

    // Ajuste das opções do PDF conforme necessidade
    await page.pdf({
      path: filePath,
      format: 'A4',
      printBackground: true,
      margin: { top: '20mm', right: '15mm', bottom: '20mm', left: '15mm' },
    });

    // Retorna o caminho acessível (relativo ao server static /public)
    return `/public/pdf/${fileName}`;
  } finally {
    await browser.close();
  }
}

module.exports = {
  gerarPDF
}
