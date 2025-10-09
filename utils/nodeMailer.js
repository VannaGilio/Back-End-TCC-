// Configuração e Função de Envio de E-mail
const nodemailer = require('nodemailer');

// Sua senha de app:
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
    // URL de redefinição no frontend (Corrigido para porta 3000, do React)
    const resetUrl = `http://localhost:3000/resetar-senha?token=${token}`; 

    const mailOptions = {
        from: '"AnalyticaAI Suporte" <analyticaai.contact@gmail.com>',
        to: toEmail,
        subject: 'Recuperação de Senha - Teste NodeMailer',
        html: `
            <h1>Redefinição de Senha</h1>
            <p>Este é um teste de funcionamento do seu NodeMailer.</p>
            <p>Clique no link abaixo para redefinir sua senha. Este link é válido por **1 hora**.</p>
            <a href="${resetUrl}" style="background-color: #3f51b5; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block;">Redefinir Senha</a>
            <p>Link direto: ${resetUrl}</p>
        `
    };

    try {
        const info = await transporter.sendMail(mailOptions);
        console.log('✅ E-mail enviado com sucesso! Resposta:', info.response);
        return true;
    } catch (error) {
        console.error('❌ ERRO ao enviar e-mail. Verifique a senha de app e o 2FA. Detalhes:', error.message);
        return false;
    }
};

// =========================================================================
// LINHA DE TESTE: Execução imediata para teste isolado.
// =========================================================================
sendPasswordResetEmail("joaosantos20071009@gmail.com", "a9b8c7d6e5f4a3b2c1d0e9f8a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3d2e1f0a9b8");

// IMPORTANTE: Manter esta linha COMENTADA enquanto você estiver testando o arquivo isoladamente!
// module.exports = { sendPasswordResetEmail }; 
