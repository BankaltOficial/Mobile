// Sistema de pontuação para determinar perfil de investidor
class InvestorProfileAnalyzer {
  
  // Função principal que calcula o perfil baseado nas respostas
  static String calculateProfile({
    required String? objective,
    required String? timeHorizon,
    required String? riskTolerance,
    required String? experience,
    required String? liquidity,
  }) {
    int score = 0;
    
    switch (objective) {
      case 'Aposentadoria':
        score += 25; 
        break;
      case 'Geração de renda':
        score += 20;
        break;
      case 'Compra de imóvel':
        score += 15; 
        break;
    }
    
    
    switch (timeHorizon) {
      case 'Longo prazo':
        score += 25;
        break;
      case 'Médio prazo':
        score += 20; 
        break;
      case 'Curto prazo':
        score += 10; 
        break;
    }
    
   
    switch (riskTolerance) {
      case 'Alta':
        score += 40; 
        break;
      case 'Moderada':
        score += 20; 
        break;
      case 'Baixa':
        score += 5;
        break;
    }
    
    switch (experience) {
      case 'Avançado':
        score += 20;
        break;
      case 'Intermediário':
        score += 15;
        break;
      case 'Iniciante':
        score += 10; 
        break;
    }
    
    switch (liquidity) {
      case 'Pode manter investimentos por longos períodos':
        score += 15; 
        break;
      case 'Precisa de acesso rápido ao capital':
        score += 5; 
        break;
    }
    
    if (score >= 85) {
      return 'ARROJADO';
    } else if (score >= 65) {
      return 'MODERADO';
    } else {
      return 'CONSERVADOR';
    }
  }
  
  // Função que retorna explicação detalhada do perfil
  static String getProfileDescription(String profile) {
    switch (profile) {
      case 'ARROJADO':
        return 'Você tem alta tolerância ao risco e busca rentabilidade superior, '
               'mesmo que isso signifique aceitar volatilidade e possíveis perdas '
               'no curto prazo. Adequado para quem tem objetivos de longo prazo.';
      
      case 'MODERADO':
        return 'Você busca equilibrio entre segurança e rentabilidade, aceitando '
               'algum nível de risco para obter retornos superiores aos '
               'investimentos mais conservadores.';
      
      case 'CONSERVADOR':
        return 'Você prioriza a segurança do capital e tem baixa tolerância ao risco. '
               'Prefere investimentos com menor volatilidade, mesmo que isso '
               'signifique retornos menores.';
      
      default:
        return 'Perfil não identificado';
    }
  }
  
  static List<String> getInvestmentSuggestions(String profile) {
    switch (profile) {
      case 'ARROJADO':
        return [
          'Fundos de ações',
          'Fundos Imobiliários',
          'Criptomoedas (pequena parte)',
          'Fundos multimercado',
        ];
      
      case 'MODERADO':
        return [
          'Fundos multimercado',
          'CDBs de bancos médios',
          'Fundos de renda fixa',
          'LCIs e LCAs',
          'Tesouro IPCA+',
          'Fundos imobiliários'
        ];
      
      case 'CONSERVADOR':
        return [
          'Tesouro Selic',
          'CDBs de bancos grandes',
          'Poupança',
          'LCIs e LCAs',
          'Fundos DI',
          'Tesouro prefixado (curto prazo)',
        ];
      
      default:
        return ['Consulte um assessor financeiro'];
    }
  }
}