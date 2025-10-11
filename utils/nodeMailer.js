// Configuração e Função de Envio de E-mail
const nodemailer = require('nodemailer')

// Substitua 'SUA_SENHA_DE_APP_AQUI' pela senha de 16 dígitos gerada no Google (Item 2.2).
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'analyticaai.contact@gmail.com', // E-mail de envio
        pass: 'ybfq ofka qpjk hcvq' 
    }
});

/**
 * Envia o e-mail de recuperação de senha.
 * @param {string} toEmail O endereço de e-mail do destinatário.
 * @param {string} token O token de recuperação gerado.
 */
const sendPasswordResetEmail = async (toEmail, token) => {
    // URL de redefinição no frontend (ajuste a porta se necessário)
    const resetUrl = `http://localhost:5173/resetar-senha?token=${token}`;

    const primaryColor = '#8B5CF6'; // Roxo da Analytica AI (Ajustado para um tom vívido)
    const grayText = '#4A5568'; // Tom de cinza escuro para o corpo do texto
    const lightGrayBackground = '#F7FAFC'; // Fundo leve

    const mailOptions = {
        from: '"AnalyticaAI Suporte" <analyticaai.contact@gmail.com>',
        to: toEmail,
        subject: 'Recuperação de Senha - AnalyticaAI',
        html: `
            <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #1A202C; background-color: ${lightGrayBackground}; padding: 20px;">
                
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; margin: 0 auto; background-color: white; border-radius: 8px 8px 0 0; border: 1px solid #E2E8F0;">
                    <tr>
                        <td align="center" style="padding: 20px;">
                            <h1 style="color: ${primaryColor}; font-size: 24px; margin: 0;">Analytica AI</h1>
                            </td>
                    </tr>
                </table>

                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 0 0 8px 8px; border: 1px solid #E2E8F0; border-top: none;">
                    <tr>
                        <td style="color: ${grayText};">
                            <h2 style="color: #1A202C; margin-top: 0; font-size: 20px;">Redefinição de Senha Solicitada</h2>
                            
                            <p style="margin-bottom: 20px; color: ${grayText};">
                                Recebemos uma solicitação para redefinir a senha associada à sua conta Analytica AI.
                            </p>

                            <table cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td align="center" style="padding: 20px 0;">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td align="center" style="border-radius: 6px;" bgcolor="${primaryColor}">
                                                    <a href="${resetUrl}" target="_blank" style="font-size: 16px; font-family: Helvetica, Arial, sans-serif; color: #ffffff; text-decoration: none; border-radius: 6px; padding: 12px 25px; border: 1px solid ${primaryColor}; display: inline-block; font-weight: bold;">
                                                        Redefinir Minha Senha
                                                    </a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>

                            <p style="font-size: 14px; text-align: center; color: #718096; margin-top: 0;">
                                Este link é válido por **1 hora**.
                            </p>
                            
                            <hr style="border: 0; border-top: 1px solid #E2E8F0; margin: 30px 0;">

                            <p style="font-size: 14px; color: ${grayText};">
                                Se você não solicitou esta redefinição de senha, por favor, ignore este e-mail. Sua senha atual permanecerá inalterada.
                            </p>

                            <p style="font-size: 12px; color: #A0AEC0; margin-top: 30px;">
                                Para sua segurança, não compartilhe este link. Se tiver problemas com o botão, use o link direto abaixo:
                            </p>
                            <p style="font-size: 12px; color: #A0AEC0; word-break: break-all;">
                                ${resetUrl}
                            </p>
                        </td>
                    </tr>
                </table>
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; margin: 10px auto;">
                    <tr>
                        <td align="center" style="font-size: 12px; color: #718096; padding-top: 10px;">
                            © ${new Date().getFullYear()} Analytica AI. Todos os direitos reservados.
                        </td>
                    </tr>
                </table>
            </div>
        `
    };

    try {
        const info = await transporter.sendMail(mailOptions);
        console.log('E-mail enviado:', info.response);
        return true;
    } catch (error) {
        console.error('Erro ao enviar e-mail:', error);
        return false;
    }
};

module.exports = { sendPasswordResetEmail };