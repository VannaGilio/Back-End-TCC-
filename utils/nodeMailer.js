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
    const resetUrl = `http://192.168.0.103:5173/resetar-senha?token=${token}`;

    const primaryColor = '#8B5CF6'; // Roxo da Analytica AI
    const grayText = '#4A5568';
    const lightGrayBackground = '#F7FAFC'; 
    const darkText = '#1A202C';

    const mailOptions = {
        from: '"AnalyticaAI Suporte" <analyticaai.contact@gmail.com>',
        to: toEmail,
        subject: 'Recuperação de Senha - AnalyticaAI',
        html: `
            <div style="font-family: Arial, sans-serif; line-height: 1.6; color: ${darkText}; background-color: ${lightGrayBackground}; padding: 20px;">
                
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; margin: 0 auto; background-color: white; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);">
                    
                    <tr>
                        <td align="center" style="padding: 25px 30px 15px 30px;">
                            <h1 style="color: ${primaryColor}; font-size: 26px; margin: 0; font-weight: bold;">Analytica AI</h1>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding: 0 40px 30px 40px; color: ${grayText};">
                            
                            <h2 style="color: ${darkText}; margin-top: 10px; font-size: 20px; text-align: center;">Redefinição de Senha Solicitada</h2>
                            
                            <p style="margin-bottom: 25px; text-align: center; color: #718096;">
                                Recebemos uma solicitação para redefinir a senha associada à sua conta Analytica AI.
                            </p>

                            <table cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td align="center" style="padding: 10px 0 25px 0;">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td align="center" style="border-radius: 8px;" bgcolor="${primaryColor}">
                                                    <a href="${resetUrl}" target="_blank" style="font-size: 16px; font-family: Helvetica, Arial, sans-serif; color: #ffffff; text-decoration: none; border-radius: 8px; padding: 15px 35px; border: 1px solid ${primaryColor}; display: inline-block; font-weight: bold;">
                                                        Redefinir Minha Senha
                                                    </a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            
                            <p style="font-size: 14px; text-align: center; color: ${grayText}; margin-top: 0; padding-bottom: 20px; border-bottom: 1px solid #E2E8F0;">
                                **Atenção:** Este link é válido apenas por **1 hora**.
                            </p>
                            
                            <p style="font-size: 14px; color: ${grayText}; margin-top: 25px;">
                                Se você **não solicitou** esta redefinição, por favor, ignore este e-mail. Sua senha atual permanecerá inalterada.
                            </p>

                            <p style="font-size: 12px; color: #718096; margin-top: 20px;">
                                Para sua segurança, não compartilhe este link. Se tiver problemas com o botão acima, copie e cole o link direto em seu navegador:
                            </p>
                            <p style="font-size: 12px; color: #718096; word-break: break-all;">
                                <a href="${resetUrl}" style="color: ${primaryColor}; text-decoration: none;">${resetUrl}</a>
                            </p>
                        </td>
                    </tr>
                </table>

                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; margin: 15px auto;">
                    <tr>
                        <td align="center" style="font-size: 12px; color: #718096;">
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